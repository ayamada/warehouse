#!/bin/bash

set -eu

which convert > /dev/null || (echo "convert not found" && exit 1)
which pngquant > /dev/null || (echo "pngquant not found" && exit 1)


QUALITY=90
TMPDIR=/tmp


TMP_LEFT=${TMPDIR}/tmp_rmch_left.png
TMP_RIGHT=${TMPDIR}/tmp_rmch_right.png
TMP_ROW_LEFT=${TMPDIR}/tmp_rmch_row_left.png
TMP_ROW_RIGHT=${TMPDIR}/tmp_rmch_row_right.png


if [ $# -lt 2 ]; then
  echo "usage: $0 path/to/leftward_character.png path/to/\\\$result_for_rpgmaker.png (convert-args)"
else
  SRC=$1
  OUT=$2
  CONVERT_ARGS=${@:3:($#-2)}
  rm -f ${TMP_LEFT} ${TMP_RIGHT} ${TMP_ROW_LEFT} ${TMP_ROW_RIGHT}
  convert ${SRC} ${CONVERT_ARGS} ${TMP_LEFT}
  convert ${TMP_LEFT} -flop ${TMP_RIGHT}
  convert +append ${TMP_LEFT} ${TMP_LEFT} ${TMP_LEFT} ${TMP_ROW_LEFT}
  convert +append ${TMP_RIGHT} ${TMP_RIGHT} ${TMP_RIGHT} ${TMP_ROW_RIGHT}
  # down left right up
  convert -append ${TMP_ROW_LEFT} ${TMP_ROW_LEFT} ${TMP_ROW_RIGHT} ${TMP_ROW_RIGHT} ${OUT}
  pngquant --ext .png -f --speed 1 --quality ${QUALITY} --strip 256 ${OUT}
  rm -f ${TMP_LEFT} ${TMP_RIGHT} ${TMP_ROW_LEFT} ${TMP_ROW_RIGHT}
  echo "created ${OUT}"
fi

# vim:set ft=sh sw=2 ts=2 et:
