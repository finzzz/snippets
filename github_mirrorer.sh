#! /bin/bash        
                           
DIR="/path/to/repos"                
TOKEN="abc123"       
                                      
RED="\e[0;91m"             
NC="\033[0m"               
                                
if [[ "$1" == "add" ]];then           
    git -C "$DIR" clone --bare "$2"
    owner=$(echo "$2" | cut -d "/" -f 4)
    repo=$(echo "$2" | cut -d "/" -f 5)
    desc=$(curl -s -H "Authorization: token $TOKEN" https://api.github.com/repos/"$owner"/"$repo" | jq -r .description)

    git -C "$repo".git config gitweb.owner "$owner"
    
    if [[ ! "$desc" == "null" ]];then
        git -C "$repo".git config gitweb.description "$desc"
    else
        git -C "$repo".git config gitweb.description ""
    fi
elif [[ "$1" == "update" ]];then                                                
    for i in "$DIR"/*.git/;do                                                    
        git -C "$i" fetch                             
    done                                                                         
elif [[ "$1" == "show" ]];then                                                   
    for i in "$DIR"/*.git/;do                                                                 
        config=$(git -C "$i" config -l)
        name=$(basename "$i" | cut -d "." -f 1)
        url=$(echo "$config" | grep remote.origin.url | cut -d "=" -f 2)
        desc=$(echo "$config" | grep gitweb.description | cut -d "=" -f 2)

        echo -e "${RED}$name${NC} $url\n$desc\n"
    done                                                                         
elif [[ "$1" == "check" ]];then                                                  
    for i in "$DIR"/*.git/;do                                                                                 
        owner=$(git -C "$i" config -l | grep remote.origin.url | cut -d "/" -f 4)                                      
        repo=$(git -C "$i" config -l | grep remote.origin.url | cut -d "/" -f 5)                                   
        is_exist=$(curl -s -H "Authorization: token $TOKEN" https://api.github.com/repos/"$owner"/"$repo" | jq -r .message)
        [[ "$is_exist" = "Not Found" ]] && echo "$owner/$repo does not exist" || echo "$owner/$repo exists"
    done                                                                                                           
else                                
    echo "Clone bare repo:"         
    echo -e "$0 add <repo url> \n"
                                                                                                                       
    echo "Update all repos:"                                                                                           
    echo -e "$0 update \n"                                                                                       
                                                                                                                   
    echo "Show repos description:"  
    echo -e "$0 show \n"          
                                    
    echo "Check if repos still exist:"
    echo -e "$0 check"          
fi                       
