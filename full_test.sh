################################################
## ce test génère le .cor de chaque fichier .s contenus dans les sous-dossiers,
## puis stocke le retour de hexdump dans un .txt, une fois avec notre asm, puis
## avec l'asm de référence.
## Il suffit ensuite de faire une diff sur test_mine.txt et test_theirs.txt pour
## détecter d'éventuelles erreurs de traitement
## note: si notre asm compile un fichier alors qu'il devrait renvoyer une erreur
## la diff n'apparait pas puisqu'elle est faite deux fois sur le même .cor. Il
## faut donc être attentif aux messages qui s'affichent sur la sortie standard
## pour ces cas spécifiques

rm test_mine.txt test_theirs.txt

i="0"

for file in $(find . -name "*.s")
do
	src[$i]=$file
	let "i = i + 1"
done

for elem in ${src[@]}
do
	echo "\n"
	echo $elem
	./asm $elem
	filename=$(echo ${elem%.*})
	fullname="${filename}.cor"
	echo $filename >> test_mine.txt
	hexdump -Cv $fullname 2> /dev/null >> test_mine.txt
	./asm_cp $elem
	filename=$(echo ${elem%.*})
	fullname="${filename}.cor"
	echo $filename >> test_theirs.txt
	hexdump -Cv $fullname 2> /dev/null >> test_theirs.txt
done

rm -rf $(find . -name "*.cor")
