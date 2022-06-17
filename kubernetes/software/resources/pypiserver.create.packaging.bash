import setuptools
import os

# 读取根目录下的 README.md 文件内容，作为项目包的详细介绍
CUR_DIR = os.path.abspath(os.path.dirname(__file__))
README = os.path.join(CUR_DIR, 'README.md')
with open('README.md', "r") as fd:
    long_description = fd.read()

setuptools.setup(
    name='hello_pypi',
    version='1.2a1',
    description='A simple hello pypi code',
    long_description=long_description,
    long_description_content_type='text/markdown',
    packages=setuptools.find_packages(),
    install_requires=[
        'colorama>=0.4.1',
        'PrettyTable'
    ],
    keywords='demo pypi hello',
)
