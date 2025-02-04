LOVE_FILE_NAME=mode7.love

lovefile:
	zip -9 -r ${LOVE_FILE_NAME} . -x "*.git*" "*.DS_Store*"

clean:
	rm -f ${LOVE_FILE_NAME}