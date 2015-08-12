#include <stdio.h>
#include <vector>
#include <iostream>
#include <stdlib.h>
#include <time.h>
#include <conio.h>

using namespace std;

#define forall(i,a,b)                   for(int i=a;i<b;i++)
#define MAXINT          100000000
#define MININT          -100000000


///////////////////////Class cordinate ////////////////////////////////////////////////////////

class cordinate
{
// Class for storing cordinates on the board
    public:
        int row;
        int col;
        cordinate()
        {}
        cordinate(int i,int j)
        {
            row=i;
            col=j;
        }
};

//////////////////////////////////////////////////////////////////////////////////////////////


cordinate emptyMove(0,0);                       // Global dummy variable defining pass as a move on position 0,0



//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++////

class state
{
// A state object stores all the information about the state of game including board configuration,scores as well as relevant functions required.
    public:
    char turn;                          // Stores x or o according to which player is going to play the move for the given state
    bool pass;                          // True if player has no move left and is going to pass
    bool finish;                        // True if no move left for both or board is full
    int comScore;                       // Computer Score
    int userScore;                      // User Score
    float alpha;                        // Alpha is the relative ratio of different evaluation functions
    vector< vector<char> > board;       // Two dimensional vector capturing the board configuration
    vector< cordinate > moves;          // Array of available moves
    void display();
    void initialise();
    void updateParameters();
    void findMoves();
    void capture(int x1,int y1,int x2,int y2,int d1,int d2);
    void playMove(cordinate c);
    bool isMove(cordinate c,bool play);
    bool isValidMove(cordinate c);
    void isFinish();
    int evaluation();
    int weightedEvaluation();
    float value();
    
};




void state :: initialise()
{
// This function initialise the board to the configuration at start of the game 
    vector <char > line(9,'_');
    forall(i,0,9)
        board.push_back(line);
    forall(i,0,9)
    {
        board[0][i]=48+i;
        board[i][0]=48+i;
    }
    board[0][0]=' ';
    board[4][4]=board[5][5]='x';
    board[4][5]=board[5][4]='o';
    turn='o';
    pass=false;
    finish=false;
    comScore=2;
    userScore=2;
}

bool state :: isValidMove(cordinate c)
{
// The function checks if a move played by the user is a part of the set of valid moves
    forall(i,0,moves.size())
        if (moves[i].row==c.row && moves[i].col==c.col) return true;
    return false;
}

void state :: isFinish()
{
// This function checks if the game has reached its final state when all the spots are occupied and also assigns score to both players
    comScore=0;
    userScore=0;
    forall(i,1,9)
    {
        forall(j,1,9)
        {
            if(board[i][j]=='x')
                comScore++;
            if(board[i][j]=='o')
                userScore++;
        }
    }
    finish = (userScore+comScore == 64 );
}

void state :: display()
{
// This function displays the present state of the game
    if (turn =='x')
        cout<<"Computer's Turn :\n";
    else
        cout<<"Your Turn :\n";
        
    forall(i,0,9)
    {
        forall(j,0,9)
            cout<<board[i][j]<<" ";
        cout<<"\n";   
    }
    cout<<"Available Moves :";
    forall(i,0,moves.size())
        cout<<"("<<moves[i].row<<","<<moves[i].col<<") ";
    cout<<"\nHuman:Computer = "<<userScore<<":"<<comScore<<"\n\n";
}

void state :: findMoves()
{
// This function finds the set of all valid moves possible for a player 
    moves.clear();
    forall(i,1,9)
    {
        forall(j,1,9)
        {
            if (board[i][j]=='x' || board[i][j]=='o')
                continue;
            cordinate c(i,j);
            if (isMove(c,false))
                moves.push_back(c);
        }   
    }
    if (pass && moves.size()==0)        // If it doesn't have any move left and last player also passed (didn't have moves left ) then game finish
        finish=true;
    pass=(moves.size()==0);           // If it does not have moves left then pass
}

bool state :: isMove(cordinate c,bool play)
{
// This function checks if move at a given cordinate is valid is play is false otherwise  if play is true it plays at the given cordinate 
    int tempX,tempY;
    forall(x,-1,2)                   // By changing values of x and y  from -1 to 1 we search in all the directions
    {
        forall(y,-1,2)
        {
            if(x==0 && y==0)
                continue; 
            tempX=c.row+x;
            tempY=c.col+y;
            if ( tempX <1 || tempX > 8 || tempY <1 || tempY >8 )
                continue;
            if (board[tempX][tempY]==turn)
                continue;
            while(true)
            {      
                if ( tempX <1 || tempX > 8 || tempY <1 || tempY >8 )
                    break;
                if (board[tempX][tempY]=='_')
                    break;
                if (board[tempX][tempY]==turn)
                {
                    if (!play)         
                        return true;
                    else
                        capture(c.row,c.col,tempX,tempY,x,y);
                    break;
                }
                tempX+=x;
                tempY+=y;
            }
        }
    }
    return false;
}
    
void state :: playMove(cordinate c)
{
// This functions plays a move at given cordinate and reconfigures the value of the state variables after playing the move
    if (c.row!=0 || c.col!=0)
        isMove(c,true);
    turn= turn=='x' ? 'o' : 'x' ;
    isFinish();
    findMoves();
}

void state :: capture(int x1,int y1,int x2,int y2,int d1,int d2)
{
// This function captures the disc between two cordinates from x1,y1 in the direcction d1,d2 till x2,y2.
    while(x1!=x2 || y1!=y2)
    {
        board[x1][y1]=turn;
        x1+=d1;
        y1+=d2;
    }
}

int state :: evaluation()
{
// Returns the evaluation of a given state
    int oCount=0,xCount=0;
    forall(i,1,9)
    {
        forall(j,1,9)
        {
            if(board[i][j]=='x')
                xCount++;
            if(board[i][j]=='o')
                oCount++;
        }
    }
    return oCount-xCount;
}

int state :: weightedEvaluation()
{
// Return the weighted evaluation where normal disc have weight 1 , discs on side weight 2 and disc on corners weight 3
    int oCount=0,xCount=0;
    int inc;
    forall(i,1,9)
    {
        forall(j,1,9)
        {
            inc=1;
            if (i==1 || i==8 )
                inc+=1;
            if (j==1 || j==8 )
                inc+=1;
            if(board[i][j]=='x')
                xCount+=inc;
            if(board[i][j]=='o')
                oCount+=inc;
        }
    }
    return oCount-xCount;
}


float state :: value()
{
    return alpha*evaluation() + (1-alpha)*weightedEvaluation();
}

//+++++++++++++++++++++++End of class State+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++///



float maxValue(state a,int depth);
float minValue(state a,int depth);

float minValue(state a,int depth)
{
// Returns the minimum value  of the max values of the successors
    state newGame;
    int numChildren=a.moves.size();
    float min=MAXINT;
    float value;
    if (depth==0)
        return a.value();
    if (numChildren==0)
    {
        a.playMove(emptyMove);
        return maxValue(a,depth-1);
    }
    forall(i,0,numChildren)
    {
        newGame=a;
        newGame.playMove(a.moves[i]);
        value=maxValue(newGame,depth-1);
        if (value < min)
            min=value;
    }
    return min;

}

float maxValue(state a,int depth)
{
// Returns the maximum value  of the min values of the successors 
    state newGame;
    int numChildren=a.moves.size();
    float max=MININT;
    float  value;
    if (depth==0)
        return a.value();
    if (numChildren==0)
    {
        a.playMove(emptyMove);
        return minValue(a,depth-1);
    }
    forall(i,0,numChildren)
    {
        newGame=a;
        newGame.playMove(a.moves[i]);
        value=minValue(newGame,depth-1);
        if (value > max)
            max=value;
    }
    return max;
}


int minmax(state a,int depth)
{
// Returns the "action" which will minimise the maxValue of its successors
    state newGame;
    int numChildren=a.moves.size();
    float min=MAXINT;
    float value;
    int index;
    forall(i,0,numChildren)
    {
        newGame=a;
        newGame.playMove(a.moves[i]);
        value=maxValue(newGame,depth-1);
        if (value < min)
        {
            index=i;
            min=value;
        }
    }
    return index;
}


int maxmin(state a,int depth)
{
    state newGame;
    int numChildren=a.moves.size();
    float max=MININT;
    float value;
    int index;
    forall(i,0,numChildren)
    {
        newGame=a;
        newGame.playMove(a.moves[i]);
        value=minValue(newGame,depth-1);
        if (value > max )
        {
            index=i;
            max=value;
        }
    }
    return index;
}

int main()
{
    srand(time(NULL));
    cordinate move;
    state game;
    int depth=4;
    game.initialise();
    game.alpha=0.5;
    game.findMoves();
    game.display();
    while(true)
    {
        if (game.turn =='o')
        {
            if (game.pass)
            {
                cout<<"You Don't have any moves left  Press any key \n\n ";
                game.playMove(emptyMove);
                getch();
            }
            else
            {
                cout<<"Enter your move \n";
                cin>>move.row>>move.col;
                cout<<"\n";
                if (!game.isValidMove(move))
                {
                    cout<<"Invalid Move . Please play a valid move \n";
                    continue;
                }
                game.playMove(move);
            }
        }
        else
        {
            if (game.pass)
            {
                cout<<"Computer doesn't have any moves left Press any key\n\n ";
                game.playMove(emptyMove);
                getch();

            }   
            else
            {
                int i = minmax(game,depth);
                game.playMove(game.moves[i]);
                cout<<"Press any key to see Computer's move \n";
                getch();
                cout<<"Move played by Computer : "<<game.moves[i].row<<" "<<game.moves[i].col<<"\n\n";
            }
        }
        game.display();
        if(game.finish)
        {
            cout<<"Game Ends\n";
            break;
        }
    }
    cout<<"Final Scores : \n Your Score : "<<game.userScore <<"\n Computer Score : "<<game.comScore;
    
    return 0;
}