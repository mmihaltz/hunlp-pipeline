./010.huntoken < test.txt > test.txt.tok
./011.hunpos-hunmorph < test.txt.tok > test.txt.posmorph
./012.stem -m --morphdel '||' test.txt.posmorph test.txt.stem
./013.chooseana.py test.txt.stem > test.txt.ana