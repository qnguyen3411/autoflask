function write_serverfile {
    printf "from flask import Flask, render_template\n"> $1
    printf "app = Flask(__name__)\n\n">> $1
    printf "@app.route('/')\n">> $1
    printf "def index():\n">> $1
    printf "\treturn render_template('index.html')\n\n">> $1
    printf "if __name__ == '__main__':\n" >> $1
    printf "\tapp.run(debug=True)\n">> $1
    echo ${yellow}--Write to ${green}$1${yellow} successful--${reset}
}

function write_html {
    printf "<html>\n">> $1
    printf "<head>\n">> $1
    printf "\t<title>Page Title</title>\n">>$1
    printf "\t<meta charset='utf-8'>\n">>$1
    printf "\t<link rel='stylesheet' type='text/css' href='{{ url_for('static', filename='stylesheet.css') }}'>\n">>$1
    printf "\t<script type='text/javascript' src='{{ url_for('static', filename='main.js') }}'></script>\n">>$1
    printf "</head>\n">> $1
    printf "<body>\n">> $1
    printf "\t<h1>Hello World</h1>\n">>$1
    printf "</body>\n">>$1
    printf "</html>\n">> $1
    echo ${yellow}--Write to ${green}$1${yellow} successful--${reset}
    
}
#colors for text formatting
green=$(tput setaf 155);
yellow=$(tput setaf 221);
reset=$(tput sgr0);

#check if flask is installed
flaskInstalled=0
pip freeze | grep -q 'Flask' && flaskInstalled=1 

if [ $flaskInstalled = 0 ]
then echo "${yellow}You don't have Flask installed!${reset}";
return 1;
fi

#take as input project name
echo ${yellow}--Enter name for new project and press [ENTER]:${reset};
read -e projectName;

#replace all spaces with underscore
projectName=$((echo "$projectName" | tr ' ' _) 2>&1)


#if name already exists, end program
if [ -d $projectName ]
    then echo ${yellow}--Already exist!--${reset};

else
    echo ${yellow}--Alrighty then!--${reset};
    printf "\n"
    echo "Making directory:              ${green}${projectName}${reset}"
    mkdir ${projectName}
    echo "Making server file:            ${green}${projectName}/${projectName}_server.py${reset}"
    touch ${projectName}/${projectName}_server.py
    echo "Making template directory:     ${green}${projectName}/templates${reset}"
    mkdir ${projectName}/templates
    echo "Making HTML file:              ${green}${projectName}/templates/index.html${reset}"
    touch ${projectName}/templates/index.html
    echo "Making static directory:       ${green}${projectName}/static${reset}"
    mkdir ${projectName}/static
    echo "Making CSS stylesheet:         ${green}${projectName}/static/stylesheet.css${reset}"
    touch ${projectName}/static/stylesheet.css
    echo "Making javascript file:        ${green}${projectName}/static/main.js${reset}"
    touch ${projectName}/static/main.js
    printf "\n"
    #ask if user wants to have files prewritten
    while true; do
        read -p "${yellow}--Do you want your server and HTML file prewritten?${green} [y/n] ${reset}" yn
        case $yn in
            [Yy]* )
                 
                write_serverfile ${projectName}/${projectName}_server.py
                write_html ${projectName}/templates/index.html
                echo "${yellow}--Done!--${reset}"
                break;;
            [Nn]* )
                echo ${yellow}--OK--${reset};
                break;;
            * )
                    echo "${yellow}--Please answer yes or no.--${reset}";;
        esac
    done

fi
