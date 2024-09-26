#!/bin/bash

# Times Tables Varialbles
NUMBER=0

#Test Variables
declare USER
LIVES=3
MAXNUMBER=0
CORRECTINAROW=0
declare -A RESULTS
declare -A USERS
STUDENTNUM=0
QUESTIONS=1
QUESTIONSDONE=0
CORRECTANSWERS=0
USERSFILE=users.txt

#main Menu
mainMenuRead(){
	local LOGIN=0
	until [[ "$LOGIN" =~ ^[1-3]$ ]]; do 
		echo "1. Student"
		echo "2. Teacher"
		echo "3. Quit the Program"
		read -p "-> " LOGIN
	
		if ! [[ "$LOGIN" =~ ^[1-4]$ ]]; then
			echo "Select Number Between 1 and 4"
		fi
	done
	mainMenu $LOGIN
}



mainMenu(){
	local LOGIN=$1
	case $LOGIN in
		1) studentMenuRead;;
		2) teacherLoginMenuRead;;
		3) echo "Thank you"
	   	   exit 0;;
		*) "Invalid Option";;
	esac
}

teacherLoginMenuRead() {
	local LOGIN=0
	until [[ "$LOGIN" =~ ^[1-4]$ ]]; do 
		echo "Are you a registered teacher ?"
		echo "1. Yes"
		echo "2. No"
		echo "3. Return to Main Menu"
		echo "4. Quit the Program"
		read -p "-> " LOGIN
	
		if ! [[ "$LOGIN" =~ ^[1-4]$ ]]; then
			echo "Select Number Between 1 and 4"
		fi
	done
	
	teacherLoginMenu $LOGIN
}

teacherLoginMenu(){
	local LOGIN=$1
	case $LOGIN in
		1) teacherLogin;;
		2) registerTeacher;;
		3) mainMenuRead;;
		4) echo "Thank you"
	   	   exit 0;;
		*) "Invalid Option";;
	esac
}

storeLoginData(){
	local NAME=$1
	local PASSWORD=$2
	local STATUS=$3

	echo "$NAME,$PASSWORD":$STATUS >> $USERSFILE
	readLoginDataToArray
}

encryptPassword(){
	local PASSWORD=$1
	echo -n $PASSWORD | openssl dgst -sha256 | cut -d' ' -f2
}


readLoginDataToArray(){
	while IFS= read -r line; do
		key=$(echo "$line" | cut -d':' -f1)
		value=$(echo "$line" | cut -d':' -f2)

		USERS["$key"]=$value
	done < "$USERSFILE"

	for key in "${!USERS[@]}"; do
		echo "Key: $key, Value: ${USERS[$key]}"
	done
}



teacherLogin(){
	echo ${USERS[@]}
	local NAME
	local PASSWORD
	local HASH
	
	until [ -n "${NAME}" ]; do
		read -p "Enter Your Name: " NAME

		if [ -z "${NAME}" ]; then
			echo "wrong"
		fi
	done

	until [ -n "${PASSWORD}" ]; do
		read -p "Enter Your Password: " PASSWORD
		HASH=$(encryptPassword $PASSWORD)

		if [ -z "${PASSWORD}" ]; then
			echo "wrong"
		fi
	done

	verifyTeacherLogin $NAME $HASH

}

verifyTeacherLogin() {
	local NAME=$1
	local PASSWORD=$2
	
	echo "Stored value for ${NAME},${PASSWORD}: ${USERS["$NAME,$PASSWORD"]}"

	if [[ "${USERS["$NAME,$PASSWORD"]}" -eq 1 ]]; then
		echo "Logged in as ${NAME}"
		USER=$NAME
		teacherMenuRead
	else	
		echo "Incorrect Login"
		teacherLoginMenuRead
	fi
}

logout(){
	unset $USER
	mainMenuRead
}

studentLogin(){
	local NAME
	local PASSWORD
}

registerTeacher(){
	local NAME
	local PASSWORD
	local HASH

	until [ -n "${NAME}" ]; do
		read -p "Enter Your Name: " NAME

		if [ -z "${NAME}" ]; then
			echo "wrong"
		fi
	done

	until [ -n "${PASSWORD}" ]; do
		read -p "Enter Your Password: " PASSWORD
		HASH=$(encryptPassword $PASSWORD)

		if [ -z "${PASSWORD}" ]; then
			echo "wrong"
		fi
	done

	storeLoginData $NAME $HASH 1
	teacherLoginMenuRead
}




#Teacher Section
teacherMenuRead(){
	local SELECT=0
	until [[ "$SELECT" =~ ^[1-5]$ ]]; do 
		echo "1. View Student Results"
		echo "2. View Student Statistics"
		echo "3. Manage Users"
		echo "4. Log Out"
		echo "5. Quit the Program"
		read -p "-> " SELECT
		echo $SELECT
	
		if ! [[ "$SELECT" =~ ^[1-5]$ ]]; then
			echo "Select Number between 1 and 4"
		fi
	done
	teacherMenu $SELECT
}

teacherMenu(){
	local SELECT=$1
	case $SELECT in
		1) viewStudentsResults;;
		2) viewStudentsStats;;
		3) manageUsers;;
		4) logout;;
		5) echo "Thank you"
	   	   exit 0;;
		*) echo "Invalid Option";;
	esac
}

viewStudentsResults(){
	echo "view Students Results"
}

viewStudentsStats(){
	echo "view Students stats"

}

manageUsers() {
	echo "manage users"
} 

#Pupil Section
studentMenuRead () {
	local SELECT=0
	CORRECTANSWERS=0
	CURRENTLIVES=$LIVES
	CORRECTINAROW=0
	until [[ "$SELECT" =~ ^[1-4]$ ]]; do 
		echo "1. Learn your 12 times tables"
		echo "2. Take the Tables Quiz"
		echo "3. Return to Main Menu"
		echo "4. Quit the Program"
		read -p "-> " SELECT
	
		if ! [[ "$SELECT" =~ ^[1-4]$ ]]; then
			echo "Select Number Between 1 and 3"
		fi
	done
	studentMenu $SELECT
}

studentMenu () {
	local SELECT=$1
	case $SELECT in
	1) learnMenuRead;;
	2) maxNumberCheckRead;;
	3) mainMenuRead;;
	4) echo "Thank you"
	   exit 0;;
	*) echo "Invalid Option Select a Number between 1 and 3" ;;
esac
}

learnMenuRead () {
	local OPERATION=0
	NUMBER=0
	until [ $OPERATION -ge 1 -a $OPERATION -le 4 ]; do
		echo "Select one of the following"
		echo "1. Addition"
		echo "2. Subtraction"
		echo "3. Multiplication"
		echo "4. Division"
		read -p "-> " OPERATION
	
		if [ $OPERATION -lt 1 -o $OPERATION -gt 4 ]; then
			echo "Select Number Between 1 and 4"
		fi
	done
	numberSelectionMenuRead $OPERATION
}

timesTables () {
	local OPERATION=$1
	case $OPERATION in
	1) additionTimesTables;;
	2) subtractionTimesTables;;
	3) multiplicationTimesTables;;
	4) divisionTimesTables;;
	*) echo "Error";;
	esac
	
}

numberSelectionMenuRead () {
	until [ $NUMBER -ge 1 -a $NUMBER -le 20 ]; do
		echo "Enter a number between 1 and 20"
		read -p "-> " NUMBER
		
		if [ $NUMBER -lt 1 -o $NUMBER -gt 20 ]; then
			echo "Enter a number between 1 and 20"
		fi
	done
	timesTables
}


additionTimesTables () {
	i=0
	while [ $i -le 12 ]; do
		ANSWER=$((NUMBER+i))
		read -p " $NUMBER + $i, = " INPUT
		
		if [ $INPUT -eq $ANSWER ]; then
			echo "Correct!"
			i=$((i+1))
		elif [ $INPUT -gt $ANSWER ]; then
			echo "Incorrect, Answer too big"
		else
			echo "Incorrect, Answer too small"
		fi
	done
	studentMenuRead

} 

additionTimesTablesShow () {
	for ((i=0; i<=12;i++)); do
		echo "$NUMBER + $i, = $((NUMBER+i))" 
	done
	studentMenuRead
}


subtractionTimesTables () {
	i=$NUMBER
	while [ $i -le $((NUMBER+12)) ]; do
		ANSWER=$((i-NUMBER))
		read -p " $i - $NUMBER, = " INPUT
		
		if [ $INPUT -eq $ANSWER ]; then
			echo "Correct!"
			i=$((i+1))
		elif [ $INPUT -gt $ANSWER ]; then
			echo "Incorrect, Answer too big"
		else
			echo "Incorrect, Answer too small"
		fi
	done
	studentMenuRead

} 

subtractionTimesTablesShow () {
	for ((i=$NUMBER;i<=$((NUMBER+12));i++)); do
		echo " $i - $NUMBER, = $((i-NUMBER))"
	done
	studentMenuRead

}

multiplicationTimesTables () {
	i=0
	while [ $i -le 12 ]; do
		ANSWER=$((NUMBER*i))
		read -p " $NUMBER * $i, = " INPUT
		
		if [ $INPUT -eq $ANSWER ]; then
			echo "Correct!"
			i=$((i+1))
		elif [ $INPUT -gt $ANSWER ]; then
			echo "Incorrect, Answer too big"
		else
			echo "Incorrect, Answer too small"
		fi
	done
	studentMenuRead
} 

multiplicationTimesTablesShow () {
	for ((i=0; i<=12;i++)); do
		echo " $NUMBER * $i, = $((NUMBER*i))"
	done
	studentMenuRead
}

divisionTimesTables () {
	i=0
	while [ $i -le 12 ]; do
		ANSWER=$((NUMBER*i))
		read -p " $((NUMBER*i)) / $NUMBER, = " INPUT
		
		if [ $INPUT -eq $i ]; then
			echo "Correct!"
			i=$((i+1))
		elif [ $INPUT -gt $i ]; then
			echo "Incorrect, Answer too big"
		else
			echo "Incorrect, Answer too small"
		fi
	done
	studentMenuRead
} 

divisionTimesTablesShow () {
	for ((i=0; i<=12;i++)); do
		echo " $((NUMBER*i)) / $NUMBER, = $i"
	done
	studentMenuRead

}

#Test Section

maxNumberCheckRead () {
	MAXNUMBER=0
	until [[ "$MAXNUMBER" =~ ^[0-9]+$ ]] && [ "$MAXNUMBER" -ge 1 ] && [ "$MAXNUMBER" -le 20 ]; do
		echo "Enter the Maximum Number"
		read -p "-> " MAXNUMBER

		if ! [[ "$MAXNUMBER" =~ ^[0-9]+$ ]]; then
			echo "Please enter a number."
		elif [ "$MAXNUMBER" -lt 1 ]; then
			echo "Max number must be 1 or greater."
		elif [ "$MAXNUMBER" -gt 20 ]; then
			echo "Max number must be 20 or less."
		fi
	done
	maxNumberCheck
}


maxNumberCheck () {
	startQuiz $MAXNUMBER
}


startQuiz () {
	echo "Contents of the array is" ${FILE[@]}

	MAX=$1
	QUESTIONSDONE=0
    for ((i=0; i<$QUESTIONS; i++)); do
        NUM1=$(((RANDOM % $MAX) + 1))
        NUM2=$((RANDOM % 13))
        OPERATOR=$((RANDOM % 4))

        echo "$((QUESTIONSDONE+1))/$QUESTIONS , Lives: $CURRENTLIVES , Correct in a row: $CORRECTINAROW"

        case $OPERATOR in
            0) makeAdditionQuestion $NUM1 $NUM2;;
            1) makeSubractionQuestion $NUM1 $NUM2;;
            2) makeMultiplicationQuestion $NUM1 $NUM2;;
            3) makeDivisionQuestion $NUM1 $NUM2;;
            *) echo "Error";;
        esac
    done
    echo "Congratulations Test complete! Your score is $CORRECTANSWERS/$QUESTIONS"
	
	writeToFile
	#readFile
    studentMenuRead
}


deductLives(){
	CORRECTANSWER=$1
	CURRENTLIVES=$((CURRENTLIVES-1))
	CORRECTINAROW=0
	echo "That is not correct! Then Correct answer is $CORRECTANSWER"

	if [ $CURRENTLIVES -eq 0 ]; then
		echo "You lost!"
		studentMenuRead
	fi
}

addLife(){
	if [ $((CORRECTINAROW%3)) -eq 0 -a $CORRECTINAROW -ne 0 ]; then
		CURRENTLIVES=$((CURRENTLIVES+1))
	fi
}

checkAnswer(){
	local USERINPUT=$1
	local ANSWER=$2
	if [ $USERINPUT -ne $ANSWER ]; then
		QUESTIONSDONE=$((QUESTIONSDONE+1))
		deductLives $ANSWER
	else
		QUESTIONSDONE=$((QUESTIONSDONE+1))
		CORRECTINAROW=$((CORRECTINAROW+1))
		CORRECTANSWERS=$((CORRECTANSWERS+1))
		addLife
	fi
	
}

makeAdditionQuestion(){
	local NUM1=$1
	local NUM2=$2
	local ANSWER=$((NUM1+NUM2))
	local USERINPUT=-1
	until [[ "$USERINPUT" =~ ^[0-9][0-9]{0,2}$ ]]; do
		read -p "$NUM1 + $NUM2 = " USERINPUT
		exitQuiz $USERINPUT

		if ! [[ "$USERINPUT" =~ ^[0-9][0-9]{0,2}$ ]]; then
			echo "Enter an Number"
		fi
	done
	recordResults $NUM1 0 $NUM2 $USERINPUT 
	checkAnswer $USERINPUT $ANSWER
}

makeSubractionQuestion(){
	local NUM1=$1
	local NUM2=$2
	local ANSWER=$NUM1
	local USERINPUT=-1
	if [ $NUM2 -eq 0 ]; then
		NUM2=1
	fi
	until [[ "$USERINPUT" =~ ^[0-9][0-9]{0,2}$ ]]; do
		read -p "$((NUM2+NUM1)) - $NUM2 = " USERINPUT
		exitQuiz $USERINPUT

		if ! [[ "$USERINPUT" =~ ^[0-9][0-9]{0,2}$ ]]; then
			echo "Enter an Number"
		fi
	done
	recordResults $((NUM2+NUM2)) 1 $NUM2 $USERINPUT
	checkAnswer $USERINPUT $ANSWER

}

makeMultiplicationQuestion(){
	local NUM1=$1
	local NUM2=$2
	local ANSWER=$((NUM1*NUM2))
	local USERINPUT=-1
	until [[ "$USERINPUT" =~ ^[0-9][0-9]{0,2}$ ]]; do
		read -p "$NUM1 * $NUM2 = " USERINPUT
		exitQuiz $USERINPUT

		if ! [[ "$USERINPUT" =~ ^[0-9][0-9]{0,2}$ ]]; then
			echo "Enter an Number"
		fi
	done

	recordResults $NUM1 2 $NUM2 $USERINPUT
	checkAnswer $USERINPUT $ANSWER
}

makeDivisionQuestion(){
	local NUM1=$1
	local NUM2=$2
	local ANSWER=$NUM1
	if [ $NUM2 -eq 0 ]; then
		NUM2=1
	fi
	local USERINPUT=-1
	until [[ "$USERINPUT" =~ ^[0-9][0-9]{0,2}$ ]]; do
		read -p "$((NUM1*NUM2)) / $NUM2 = " USERINPUT
		exitQuiz $USERINPUT

		if ! [[ "$USERINPUT" =~ ^[0-9][0-9]{0,2}$ ]]; then
			echo "Enter an Number"
		fi
	done
	
	recordResults $((NUM1*NUM2)) 3 $NUM2 $USERINPUT
	checkAnswer $USERINPUT $ANSWER
}

exitQuiz(){
	local INPUT=$1
	if [[ $INPUT =~ 999 ]]; then
		studentMenuRead
	fi
	
}

# Arrays and data Storage
recordResults(){
	local NUM1=$1
	local OPERATOR=$2
	local NUM2=$3
	local INPUT=$4
	local QUESTION=$QUESTIONSDONE

	RESULTS["${QUESTION},0"]=$NUM1
	RESULTS["${QUESTION},1"]=$OPERATOR
	RESULTS["${QUESTION},2"]=$NUM2
	RESULTS["${QUESTION},3"]=$INPUT
}

writeToFile(){
	FILE=$"data.txt"
	if [ ! -f $FILE ]; then
		touch $FILE
	fi

	for key in "${!RESULTS[@]}"; do
			echo -ne "$key: ${RESULTS[$key]}\n" >> $FILE
	done
}


readFile(){
#currently doesnt read file just array
	local index=0
	while read LINE; do
		RESULTS[$index]="$LINE"
	done < $FILE
	echo "read"

	for key in "${!RESULTS[@]}"; do
  		echo -ne $key: ${RESULTS[$key]}
	done
}

readLoginDataToArray
while true; do
	mainMenuRead
done
