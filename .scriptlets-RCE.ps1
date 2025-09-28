mkdir SPOPSM-NL12143-GITHUB
cd SPOPSM-NL12143-GITHUB

PWD


git clone https://github.com/NL12143/SPOPSM.git SPOPSM-NL12143-GITHUB


git clone https://github.com/NL12143/SPOPSM.git .
That trailing dot (.) means “clone into the current directory.”
“Clone the contents directly into this folder, don’t nest it.”

cd..
Remove-Item -Recurse -Force .\SPOPSM-NL12143-GITHUB
