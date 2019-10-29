# Make the script being able to load kicad_netlist_reader
import sys
sys.path.append('/usr/share/kicad/plugins/')

import kicad_netlist_reader
from jinja2 import Template
import os

class Group:
    def __init__(self):
        self.refs = []
        self.value = None
        self.vendor = None
        self.vendor_ref = None
        self.manufacturer = None
        self.manufacturer_ref = None
        self.price = None
        self.url = None

    @property
    def cost(self):
        if self.price is None:
            return None
        else:
            return self.price * len(self.refs)

netlist = kicad_netlist_reader.netlist(sys.argv[1])
components = netlist.getInterestingComponents()

groups = []
for g in netlist.groupComponents(components):
    group = Group()
    groups.append(group)
    c = None

    for component in g:
        group.refs.append(component.getRef())
        c = component

    group.value = c.getValue().decode('utf8')
    group.vendor = c.getField('Vendor')
    group.vendor_ref = c.getField('VendorRef')
    group.manufacturer = c.getField('Manufacturer')
    group.manufacturer_ref = c.getField('ManufacturerRef')
    s = c.getField('Price')
    if len(s):
        group.price = float(s)
    if group.vendor == 'Farnell':
        group.url = 'https://fr.farnell.com/search?st=' + group.vendor_ref
    elif group.vendor == 'Mouser':
        group.url = ('https://www.mouser.fr/Search/Refine?Keyword='
            + group.vendor_ref)

total_cost = 0
for g in groups:
    cost = g.cost
    if cost is not None:
        total_cost += cost

template_path = os.path.join(os.path.dirname(sys.argv[2]), 'bom-template.html')
template = Template(open(template_path).read())
html = template.render(components=components, groups=groups,
    total_cost=total_cost)

with open(sys.argv[2] + '.html', 'wb') as f:
    f.write(html.encode('utf8'))
    pass

with open(sys.argv[2] + '.csv', 'wb') as f:
    for g in groups:
        line = ';'.join([' '.join(g.refs), str(len(g.refs)), g.value,
            g.manufacturer, g.manufacturer_ref])
        f.write((line + '\n').encode('utf8'))
