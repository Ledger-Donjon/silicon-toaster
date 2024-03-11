from setuptools import setup, find_packages

setup(
    name="silicon-toaster",
    version="1.1",
    packages=["silicontoaster", "silicontoaster.gui"],
    install_requires=["pyserial"],
    url="",
    license="GNU LGPL",
    author="Olivier Hérivaux",
    author_email="olivier.herivaux@ledger.fr",
    description="",
    python_requires=">=3.9",
)
