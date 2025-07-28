#!/usr/bin/env zsh

#########################
#
# Author: Thomas "Maaseh" Bonnet
# Name: Git-function.zsh
# Description: Fonctions creation
# to simplify the git usage
#
#########################

# Helpers

function select-repo() {
	local message="$1"
	local counter=1
	GH_List=($(gh repo list))
	echo "Repository list: "
	for action in "${GH_List[@]}"; do
		echo "$counter. $action"
		((counter++))
	done
	while true; do
		echo -n "$message (1-${#GH_List[@]}):" 
		read Repo_Selection
		if [[ $Repo_Selection =~ ^[1-9]+$ ]] && [[ $Repo_Selection -ge 1 ]] && [[ $Repo_Selection -le ${#GH_List[@]} ]]; then
			Repo_line="${GH_List[$Repo_Selection]}"
			Repo_choice=$(echo "$Repo_line" | awk '{print$1}' | cut -d'/' -f2)
			echo "$Repo_choice"
			return 0
		else
			echo "Invalid selection, please try again"
		fi
	done
}

function confirm-action() {
	local message="$1"
	while true; do
		echo -n "$message (y/n)" 
		read yn
		case $yn in
			[Yy]* ) return 0; break;;
			[Nn]* ) return 1; break;;
			* ) echo "Please select a valid answer (Yes or No)";;
		esac
	done
}

# Interactive repo function: Simplify the repository management
function repo-management() {
	GitAction=("Create a repo" "Delete a repo" "Archive a repo" "Change the visibility" "Rename a repo" "Clone a repo")
	local counter=1
	echo "=== Welcome to the repository management ==="
	echo "$(date)"
	echo " Available actions:"
	for action in "${GitAction[@]}"; do
		echo "$counter. $action"
		((counter++))
	done
	while true; do
		echo -n "Select an action (1-${#GitAction[@]}): " 
		read CHOICE
		if [[ $CHOICE =~ ^[0-9]+$ ]] && [[ $CHOICE -ge 1 ]] && [[ $CHOICE -le ${#GitAction[@]} ]]; then
			GA_Action="${GitAction[$CHOICE]}"; break
		else 
			echo "Please select a valid answer"
		fi
	done
	case $GA_Action in 
		"Create a repo")
			echo -n "Please choose a name for the repo: " 
			read GA_Name
			while true; do
				echo "Please select a source Directory: "
				vared -p "Path: " GA_Filepath
				echo "You selected this path: $GA_Filepath"
				if [ -d "$GA_Filepath" ]; then
					break
				else
					echo "Please select a correct path"
				fi
			done
			while true; do
				echo -n "Do you want this repo to be public? (y/n)" 
				read yn
				case $yn in
					[Yy]* ) GA_Visibility="--public"; break;;
					[Nn]* ) GA_Visibility="--private"; break;;
					* ) echo "Please select a valid answer (Yes or No)";;
				esac
			done
			echo -n "Please add a description for the repo: " 
			read GA_Description
			while true; do
				echo -n "Do you want to add a README.MD? (y/n)" 
				read yn
				case $yn in
					[Yy]* ) GA_Readme="--add-readme"; break;;
					[Nn]* ) GA_Readme=""; break;;
					* ) echo "Please select a valid answer (Yes or No)";;
				esac
			done
			echo "Repository creation..."
			mkdir "$GA_Filepath"/"$GA_Name"
			git -C $GA_Filepath/"$GA_Name" init
			gh repo create "$GA_Name" $GA_Visibility --description "$GA_Description" --source "$GA_Filepath" $GA_Readme
			echo "$GA_Name has been created. Location: $GA_Filepath"; return 0 
		;;

		"Delete a repo")
			Repo_Selected=$(select-repo "Please select a repo to delete")
			if confirm-action "Are you sure you want to delete the repo named $Repo_Selected ?"; then
				echo "Deletion in progress...."
				gh repo delete "$Repo_Selected" --yes
				return 0
			else
				echo "Cancelling...."
				return 1
			fi
		;;

		"Archive a repo")	
			Repo_Selected=$(select-repo "Please select a repo to archive")
			if confirm-action "Are you sure you want to archive the repo named $Repo_Selected ?"; then
				echo "Archive in progress...."
				gh repo archive "$Repo_Selected" --yes
				return 0
			else
				echo "Cancelling...."
				return 1
			fi
		;;

		esac
}

