#! /bin/bash

#   Description:
#       cinit.zsh initializes a C project named PROJECT_NAME, with my
#       typical directory-structure:
#
#           PROJECT_NAME/
#               src/
#                   PROJECT_NAME.c
#                   PROJECT_NAME.h
#               makefile
#
#       cinit performs all necessary keyword insertions within project files
#       (ie, inserting the makefile's target names).
#
#   Use:
#       ./cinit.zsh PROJECT_NAME
#
#       PROJECT_NAME -- name of the project

create_makefile(){
	# Create the project's `makefile`.

	cp ~/.dotfiles/res/_cinit/make.tmp makefile
	sed -i "s/__PROJECTNAME__/$projectName/g" makefile
}

create_source_files(){
	# Create the `src/` directory, and the project's main source files.

	mkdir src
	touch src/$projectName.h
	cp ~/.dotfiles/res/_cinit/c.tmp src/$projectName.c
	sed -i "s/__PROJECTNAME__/$projectName/g" src/$projectName.c
}

confirm_git_initialization(){
	# Initialize git in the project, with the user's permission.

	while true; do
		read -p "Init git? [y/n] " -n 1 -r
		echo
		[[ "$REPLY" =~ ^[YyNn]$ ]] && break
		echo "Please enter 'y' or 'n'."
	done

	if [[ "$REPLY" =~ ^[Yy]$ ]]; then
		git init > /dev/null
		echo "$projectName" > .gitignore
		echo "#$projectName" > README.md
	fi
}

create_project(){
	# Initialize all of the project's directories and files.

	mkdir $projectName
	cd $projectName

	create_makefile
	create_source_files
	confirm_git_initialization
}

main(){
	echo "Begin initializing "$1"."
	projectName=$1
	create_project
	echo "Initialization complete."
}

main $1
