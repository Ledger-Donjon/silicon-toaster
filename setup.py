from setuptools import setup, find_packages

setup(
    name="silicon-toaster",
    version="1.2",
    packages=["silicontoaster"],
    install_requires=["pyserial", "hug"],
    url="",
    license="GNU LGPL",
    author="Olivier Hérivaux",
    author_email="olivier.herivaux@ledger.fr",
    description="",
    python_requires=">=3.9",
)
