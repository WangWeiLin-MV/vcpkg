
pip_precandidate_installation='pip_precandidate/installation/lib/site-packages/pip'
pip_precandidate_patch_file='py-pip-24.0-precandidate.diff'

git init
git apply -C $pip_precandidate_installation $pip_precandidate_patch_file --ignore-space-change --ignore-whitespace 
