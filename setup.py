from setuptools import setup, find_packages

setup(
    name='silicon-toaster',
    version='1.0',
    packages=['silicontoaster'],
    install_requires=['pyserial'],
    url='',
    license='GNU LGPL',
    author='Olivier Hérivaux',
    author_email='olivier.herivaux@ledger.fr',
    description='',
    package_data={'': ['../calibration_voltage.log']},
    include_package_data=True,
    python_requires=">=3.4"
)
