from setuptools import setup, find_packages
from os import path
import versioneer

cur_dir = path.abspath(path.dirname(__file__))

# parse requirements
with open(path.join(cur_dir, "requirements.txt"), "r") as f:
    requirements = f.read().split()

setup(
    name="my_model",
    author="Jacqueline Garrahan",
    version=versioneer.get_version(),
    cmdclass=versioneer.get_cmdclass(),
    packages=find_packages(),
    #  license="...",
    install_requires=requirements,
    url="https://github.com/jacquelinegarrahan/my-model",
    include_package_data=True,
    python_requires=">=3.8",
    entry_points={
        "orchestration": [
            "my_model.model=\
                my_model.model:MyModel",
            "my_model.flow=\
                my_model.flow:get_flow",
        ],
        "console_scripts": [
            "plot-flow=my_model.scripts.plot:main"
        ],
    },
)
