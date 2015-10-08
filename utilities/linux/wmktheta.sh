#!/usr/bin/env bash

typeset reset="\033[0;0;0m"
typeset wobnb="\033[0;37;44m"
typeset wob="\033[1;37;44m"
typeset wog="\033[1;37;40m"
typeset worb="\033[1;37;41m"
typeset rowb="\033[1;31;47m"
typeset wor="\033[0;37;41m"
typeset row="\033[0;31;47m"
typeset s="> /dev/null"
typeset ss="2>&1 >/dev/null"

if [[ "$1" == "--version-commit" || "$1" == "-g" || "$2" == "--version-commit" || "$2" == "-g" ]]; then
	typeset git=false
else
	typeset git=true
fi

if [[ "$1" == "--jenkins" ]]; then
	typeset git=true
	typeset no="-$(date +\"%y%m%d-%H%M\")-$(git log -1 --format=%h)"
	typeset jenkins=true
	chmod 755 out
fi

x() {
    typeset cmnd="$1"
    typeset msg="$2"
    typeset ret_code
	if [[ $# -eq 2 ]]; then
		echo -en "${wob} $msg "
	fi
    eval $cmnd
    ret_code=$?
    if [[ $ret_code != 0 ]]; then
            err "task returned ${ret_code}, expected 0"
    else
		if [[ $# -eq 2 ]]; then
            success " okay "
		fi
    fi

}

err() {
    typeset err="$*"
    echo -e "\033[1;37;41mfatal:\033[0;37;41m ${err}${reset}"
    exit 1
}

success() {
    typeset msg="$*"
    echo -e "\033[1;37;42m ${msg} ${reset}"
}

if [[ -d "out" && "$jenkins" != true ]]; then
	x "rm -rf out"
fi

x "utilities/linux/gitcommit c src/code/acs_src/gitcommit.acs --silent" "Making gitcommit.acs"
x "utilities/linux/genver c src/code/acs_src/version.acs --silent" "Making version.acs"
x "utilities/linux/genver bash utilities/version.sh --silent"
eval "$(cat utilities/version.h)"

if [[ "$1" == "--no-version" || "$1" == "-n" || "$2" == "--no-version" || "$2" == "-n" ]]; then
	typeset no=""
else
	if [[ git == true ]]; then
		typeset no="-${VERSION_STRING}-$(git log -1 --format=%h)"
	else
		typeset no="-${VERSION_STRING}"
	fi
fi


x "mkdir -p src/code/acs" "Making acs output folder"
x "utilities/linux/acc src/code/acs_src/aow2scrp.acs src/code/acs/aow2scrp.o" "Compiling ACS ${reset}"
x "utilities/linux/acsconstants src/code/acs_src/aow2scrp.acs src/code/actors/acsconstants.dec ${s}" "Generating ACS -> Decorate constants"

x "cd src/base/"
x "7za a -tzip \"../../out/theta_base${no}.pk3\" -r -xr!*.dbs -xr!*.backup1 -xr!*.backup2 -xr!*.backup3 -xr!*.bak ." "Packaging base ${reset}"

cd ../../
cd src/code/
x "7za a -tzip \"../../out/theta_code${no}.pk3\" -r -xr!*.dbs -xr!*.backup1 -xr!*.backup2 -xr!*.backup3 -xr!*.bak ." "Packaging code ${reset}"

cd ../../
cd src/maps/
x "7za a -tzip \"../../out/theta_maps${no}.pk3\" -r -xr!*.dbs -xr!*.backup1 -xr!*.backup2 -xr!*.backup3 -xr!*.bak ." "Packaging maps ${reset}"

cd ../../
cd src/music/
x "7za a -tzip \"../../out/theta_music${no}.pk3\" -r -xr!*.dbs -xr!*.backup1 -xr!*.backup2 -xr!*.backup3 -xr!*.bak ." "Packaging music ${reset}"


cd ../../
echo
echo The PK3 files are to be found in:
echo Commit:
echo -e "$(git log -1 --format="\t%Cred%H%Creset%n\t%Cgreen%s%Creset %n\t%Cblue%aN <%aE>")"
echo -e "\tBuild number \#${no}"
