########################################################################
#                       Distrivia Phase 2 Readme                       #
#                     Instructions for installation                    #
#                              and usage                               #
########################################################################

Authors:
Brian Gianforcaro
Steven Glazer
Sam Milton

Installation
	1. Servers
		The servers are up and running along with the load sharers.
	Everything concerning the server is ready to go and requires no
	installation.
	
	2. Web Client
		No installation necessary. Simply open your preferred web browser
	and navigate to distrivia.lame.ws. The web client will display the
	login/register screen. Instructions on how to use the web client are
	below.
	
	3. Android Client
	    a) Simulator - Open Eclipse (must be setup with Android SDK). 
	        From the menu, select File->Import... When the window pops up,
	        select "Exisiting Project" from the "General" folder. Navigate
	        the import window to:
	            /src/clients/android
	        Select the project and click through to complete import. When
	        the project is loaded, you may Run as Android Application. This
	        will launch the Android Simulator and load the application.
	    b) Device - follow the steps followed at the following link:
	        http://developer.android.com/guide/developing/device.html

	4. iPhone Client
		Currently, the iPhone client does no talking to the server. 
	But if you would like to install and look at the UIs and progress,
	follow these instructions.
		a) Simulator - Open the XCode project file using a Mac:
			/src/clients/iphone/distrivia/distrivia.xcodproj
		   Select to use the simulator and make sure you have
		   iPhone selected from the dropdown box in the upper-left.
                   The simulator should pop open and load the app.
		b) Device - For this to work, the device must be registered
		   with the "CS Development" Provisioning Profile. If this
		   is the case, follow the same steps for running the app
		   using the simulator (above) but choose device from the
		   dropdown box instead of simulator.
		   The app will install on the device and run 
		   automatically.
	
	
Usage
		The web, android, and iPhone clients share the same format to make it
	easy to navigate and understand each client without learning a new
	interface. The gameplay for our application is broken up into 4
	distinct activities or screens: login/register, join public/private, 
	compete, and view leaderboard. The activities work in this order and
	descriptions of the activities and how to use them is explained below. The
	iPhone client currently only shows the views and does not support any of
	the functionality of the application.
	
	1. Login/Register
		This is the first screen you will see when loading from any client. 
	If you have not previously registered a username and password, you will 
	want to type a username and password and select the "Register" button. 
	Otherwise, if you have a username completed, you may type your username 
	and password in and select the "login" button. If login/registration is 
	successful, you will be taken to the join screen. Otherwise, make sure 
	you are using the correct username and password and try again.
	
	2. Join (Public/Private)
		The join screen gives you the option to join a public round,
	compete in a private round, or view the current global leaderboard.
	Currently, private round competition is	not available. 
		If you would like to view the current global leaderboard, you 
	may select the "View Leaderboard" button. The global leaderboard 
	shows the standing of the players based on all their rounds 
	they've played. 
		If you're ready to compete in a public game, select the 
	"Join Public" button. You will be shown a waiting screen until
	enough players have joined public games to compete with. Currently,
	the number of players in a public game to start a round is 2. Once
	enough players have joined, the round will begin and you will be 
	taken to the compete screen.
	
	3. Compete
		The competition screen will display a series of questions and
	and answers. Currently, this screen is only fully implemented on
	the web client. Read the question, select an answer and then select the
	"Ok" button. This will submit your answer and you will be given more
	questions and answers until the round is over. Depending on the client,
	you will see different reactions for whether you have answer the
	question correctly. Once the round is completed, you will be taken back
	to the join screen to join another round. If you are competing on the
	android or iphone client, you will be taken to the round leaderboard to 
	see the	scores of the other players in the round. For the web client 
	this is	shown while in the round.
	
	4. View Leaderboard
		The leaderboard screen shows the standings of players of Distrivia.
	There are two forms of the leaderboard. One leaderboard shows the players
	with the global rankings. This global leaderboard can be accessed from the
	join screen using the "View Global Leaderboard" button. The other leaderboard
	shows the rankings of the players in a round. For the web client, this is
	shown while competing in the round. For the android and iphone clients, 
	this is shown upon completion of the round.
	
	