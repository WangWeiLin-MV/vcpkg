
pip_install_find_links='pip_precandidate/workspace/prepared'

python pip.py install -f pip_install_find_links --no-index --find-links=dist --no-deps numpy
