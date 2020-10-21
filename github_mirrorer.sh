#! /bin/bash        
                           
DIR="/path/to/repos"                
TOKEN="abc123"       
                                      
RED="\e[0;91m"             
NC="\033[0m"               
                                
if [[ "$1" == "add" ]];then           
    git -C "$DIR" clone --bare "$2"                                                        
elif [[ "$1" == "update" ]];then                                                
    for i in $(ls -d "$DIR"/*.git/);do                                                                 
        git -C "$i" fetch                             
    done                                                                         
elif [[ "$1" == "show" ]];then                                                   
    for i in $(ls -d "$DIR"/*.git/);do                                                                 
        owner=$(git -C "$i" config -l | grep remote.origin.url | cut -d "/" -f 4)                      
        repo=$(git -C "$i" config -l | grep remote.origin.url | cut -d "/" -f 5) 
        json_data=$(curl -s -H "Authorization: "$TOKEN"" https://api.github.com/repos/"$owner"/"$repo")
        desc=$(echo "$json_data" | jq -r .description)                    
        link=$(echo "$json_data" | jq -r .html_url)   
                                                   
        echo -ne "${RED}"$owner"/"$repo"${NC} "                                  
        [[ "$link" == "null" ]] || echo -n "$link"
        echo ""                                 
        [[ "$desc" == "null" ]] || echo "$desc"                                                                     
        echo ""                                                                                               
    done                                                                         
elif [[ "$1" == "check" ]];then                                                  
    for i in $(ls -d "$DIR"/*.git/);do                                                                                 
        owner=$(git -C "$i" config -l | grep remote.origin.url | cut -d "/" -f 4)                                      
        repo=$(git -C "$i" config -l | grep remote.origin.url | cut -d "/" -f 5)                                   
        is_exist=$(curl -s -H "Authorization: "$TOKEN"" https://api.github.com/repos/"$owner"/"$repo" | jq -r .message)
        [[ "$is_exist" = "Not Found" ]] && echo ""$owner"/"$repo" does not exist" || echo ""$owner"/"$repo" exists"
    done                                                                                                           
else                                
    echo "Clone bare repo:"         
    echo -e ""$0" add <repo url> \n"
                                                                                                                       
    echo "Update all repos:"                                                                                           
    echo -e ""$0" update \n"                                                                                       
                                                                                                                   
    echo "Show repos description:"  
    echo -e ""$0" show \n"          
                                    
    echo "Check if repos still exist:"
    echo -e ""$0" check"          
fi                       