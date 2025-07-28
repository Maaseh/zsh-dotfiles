#########################
#
# Author: Thomas "Maaseh" Bonnet
# Name: Git-function.zsh
# Description: Fonctions creation
# to simplify the git usage
#
#########################

#Variable
GitAction=("Create a repo", "Delete a repo", "Archive a repo", "Change the visibility", "Rename a repo", "Clone a repo")

# Helpers

function select-repo() {
	local message="$1"
	GH_List=($(gh repo list))
	echo "Repository list: "
	for i in "${!GH_List[@]}"; do
		echo "$((i+1)), ${GH_List[i]}"
	done
	while true; do
		read -p "$message (1-${#GH_List[@]}):" Repo_Selection
		if [[ $Repo_Selection =~ ^[1-9]+$ ]] && [[ $Repo_Selection -ge 1 ]] && [[ $Repo_Selection -le ${#GH_List[@]} ]]; then
			Repo_line="${GH_List[$((Repo_Selection-1))]}"
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
		read -p "$message (y/n)" yn
		case $yn in
			[Yy]* ) return 0; break;;
			[Nn]* ) return 1; break;;
			* ) echo "Please select a valid answer (Yes or No)";;
		esac
	done
}

# Interactive repo function: Simplify the repository management
function repo-management() {
	#Variable
	GitAction=("Create a repo", "Delete a repo", "Archive a repo", "Change the visibility", "Rename a repo", "Clone a repo")
	echo "=== Welcome to the repository management ==="
	echo $(date)
	echo " Available actions:"
	for i in "${!GitAction[@]}"; do
		echo "$((i+1)). ${GitAction[i]}"
	done

	while true; do
		read -p "Select an action (1-${#GitAction[@]}): " CHOICE
		if [[ $CHOICE =~ ^[0-9]+$ ]] && [[ $CHOICE -ge 1 ]] && [[ $CHOICE -le ${#GitAction[@]} ]]; then
			GA_Action="${GitAction[$((CHOICE-1))]}"; break
		else 
			echo "Please select a valid answer"
		fi
	done
	case $GA_Action in 
		"Create a repo")
			read -p "Please choose a name for the repo: " GA_Name
			while true; do
				echo "Please select a Directory"
				read GA_Filepath
				if [ -d $GA_Filepath ]; then
					break
				else
					echo "Please select a correct path"
				fi
			done
			while true; do
				read -p "Do you want this repo to be public? (y/n)" yn
				case $yn in
					[Yy]* ) GA_Visibility="--public"; break;;
					[Nn]* ) GA_Visibility="--private"; break;;
					* ) echo "Please select a valid answer (Yes or No)";;
				esac
			done
			read -p "Please add a description for the repo: " GA_Description
			while true; do
				read -p "Do you want to add a README.MD? (y/n)" yn
				case $yn in
					[Yy]* ) GA_Readme="--add-readme"; break;;
					[Nn]* ) GA_Readme=""; break;;
					* ) echo "Please select a valid answer (Yes or No)";;
				esac
			done
			while true; do
				read -p "Do you want to add a .gitignore? (y/n)" yn
				case $yn in
					[Yy]* ) GA_Ignore="--gitignore"; break;;
					[Nn]* ) GA_Ignore=""; break;;
					* ) echo "Please select a valid answer (Yes or No)";;
				esac
			done
			echo "Repository creation..."
			gh repo create "$GA_Name" "$GA_Visibility" --description "$GA_Description" --source "$GA_Filepath" "$GA_Readme" "$GA_Ignore"
			echo "$GA_Name has been created. Location: $GA_Filepath" exit 
		;;

		"Delete a repo")
			Repo_Selected=$(select-repo "Please select a repo to delete")
			if confirm-action "Are you sure you want to delete the repo named $Repo_Selected ?"; then
				echo "Deletion in progress...."
				gh repo delete "$Repo_Selected" --yes
				break
			else
				echo "Cancelling...."
				exit
			fi
		;;

		"Archive a repo")	
			Repo_Selected=$(select-repo "Please select a repo to archive")
			if confirm-action "Are you sure you want to archive the repo named $Repo_Selected ?"; then
				echo "Archive in progress...."
				gh repo archive "$Repo_Selected" --yes
				break
			else
				echo "Cancelling...."
				exit
			fi
		;;

		esac
}

