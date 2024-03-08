import os

__dirname = os.path.dirname(os.path.realpath(__file__))


def resource_path(path: str) -> str:
    """
    Transforms a .":/path/to/file" path to the relative path from the main script
    """
    if not path.startswith(":/"):
        return path
    return os.path.join(__dirname, path[2:])
