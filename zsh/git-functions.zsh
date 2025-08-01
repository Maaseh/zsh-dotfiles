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
	GH_List=($(gh repo list --json name --jq '.[].name'))
	echo "Repository list: "
	for repo in "${GH_List[@]}"; do
		echo "$counter. $repo"
		((counter++))
	done
	while true; do
		echo -n "$message (1-${#GH_List[@]}):" 
		read Repo_Selection
		if [[ $Repo_Selection =~ ^[1-9]+$ ]] && [[ $Repo_Selection -ge 1 ]] && [[ $Repo_Selection -le ${#GH_List[@]} ]]; then
			Repo_line="${GH_List[$Repo_Selection]}"
			Repo_choice=$(echo "$Repo_line" | awk '{print $1}' | cut -d'/' -f2)
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
			GA_Action="${GitAction[$CHOICE]}"
			break
		else 
			echo "Please select a valid answer"
		fi
	done
	case $GA_Action in 
		"Create a repo")
			echo ""
			echo "=== Create a repo ==="
			echo ""
			echo -n "Please choose a name for the repo: " 
			read GA_Name
			GA_Filepath=""
			while true; do
				vared -p "Please select a source Directory: " GA_Filepath
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
			touch "$GA_Filepath"/"$GA_Name"/.gitignore
			git -C "$GA_Filepath"/"$GA_Name" init
			gh repo create "$GA_Name" $GA_Visibility --description "$GA_Description" --source "$GA_Filepath" $GA_Readme
			echo "$GA_Name has been created. Location: $GA_Filepath"; return 0 
		;;

		"Delete a repo")
			echo ""
			echo "=== Delete a repo ==="
			echo ""
			select-repo "Please select a repo to delete"
			Repo_Selected=$Repo_choice
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
			echo ""
			echo "=== Archive a repo ==="
			echo ""
			select-repo "Please select a repo to archive"	
			Repo_Selected=$Repo_choice
			if confirm-action "Are you sure you want to archive the repo named $Repo_Selected ?"; then
				echo "Archive in progress...."
				gh repo archive "$Repo_Selected" --yes
				return 0
			else
				echo "Cancelling...."
				return 1
			fi
		;;

		"Change the visibility")
			echo ""
			echo "=== Change the visibility of a repo ==="
			echo ""
			select-repo "Please select a repo you want to change the visibility"
			Repo_Selected=$Repo_choice
			CURRENT_VISIBILITY=$(gh repo view "$Repo_Selected" --json visibility --jq '.visibility')
			if [[ "$CURRENT_VISIBILITY" == "PUBLIC" ]]; then
        			if confirm-action "Change visibility from PUBLIC to PRIVATE?"; then
            				gh repo edit "$Repo_Selected" --visibility private
            				echo "Repository visibility changed to private"
        			fi
    			else
        			if confirm-action "Change visibility from PRIVATE to PUBLIC?"; then
            				gh repo edit "$Repo_Selected" --visibility public
            				echo "Repository visibility changed to public"
        			fi
    			fi
		;;

		"Rename a repo")
			echo ""
			echo "=== Remane a repo ==="
			echo ""
			select-repo "Please select a repo you want to rename"
			Repo_Selected=$Repo_choice
			echo -n "Please enter the new repo's name: "
			read New_Repo_Name
			if confirm-action "Are you sure you want to rename the repo $New_Repo_Name ?"; then
				echo "Name change in progress"
				gh repo rename "$Repo_Selected" "$New_Repo_Name" --yes
				return 0
			else
				echo "Cancelling..."
				return 1
			fi
		;;
		
		"Clone a repo")
			echo ""
			echo "=== Clone a repo ==="
			echo ""
			if confirm-action "Do you want to clone one of your repo? "; then
				select-repo "Please select a repo you want to clone"
				Repo_Selected=$Repo_choice
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
				if confirm-action "Are you sure you want to clone $Repo_Selected here: $GA_Filepath ?"; then
					echo "Clone in progress...."
					gh repo clone "$Repo_Selected" "$GA_Filepath"/"$Repo_Selected"
					return 0
				else
					echo "Cancelling..."
					return 1
				fi
			else
				echo -n "Please enter the github repo's URI you want to clone: "
				read GH_URI
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
				if confirm-action "Are you sure you want to clone $GH_URI here: $GA_Filepath ?"; then
					echo "Clone in progress..."
					gh repo clone "$GH_URI" "$GA_Filepath"
					return 0
				else
					echo "Cancelling..."
					return 1
				fi
			fi
		;;
	esac
}

