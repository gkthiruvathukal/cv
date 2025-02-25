#!/bin/bash

MAIN_TEX=./cv-main.tex
DATA_DIR=./data

[[ -f $MAIN_TEX ]] && mv $MAIN_TEX $MAIN_TEX.BAK

cat >> $MAIN_TEX <<EOF
% DO NOT EDIT - automatically generated!
% Edit individual sections in ./data instead.

\documentclass[10pt,letterpaper,sans]{moderncv} 

\input{settings}

EOF

for f in $DATA_DIR/0[0-9]-*.tex
do
  echo "\\input{$f}" >> $MAIN_TEX
done

cat >> $MAIN_TEX <<EOF

\begin{document}

\makecvtitle

EOF

for f in $DATA_DIR/[1-9][0-9]-*.tex
do
  echo "\\input{$f}" >> $MAIN_TEX
done

cat >> $MAIN_TEX <<EOF

\end{document}
EOF
