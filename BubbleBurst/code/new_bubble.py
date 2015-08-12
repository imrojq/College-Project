from numpy import *
from random import *
import copy


def rightshift(j,board):
    '''This function is used to shift each column which are
    left side of a compltely bursted column to right side'''
    num=len(board)
    #This loop shifts each column rightwards
    for i in range(j,0,-1):
        board[0:,i]=board[0:,i-1]
    board[0:,0]=0


def downshift(x,y,jump,board):
    '''This function is used to bring down the remaining bubble
    in a column when a bubble is burst and replace empty space with -1'''
    num=len(board)
    board[jump:x+jump,y]=board[0:x,y]   #Shifts donw elements to fill the empty space
    board[0:jump,y]=0                  #Assigns -1 to the empty space on the top
    if board[num-1,y]==0:              #If bottommost elements become zero then shift all column rightwars
        rightshift(y,board)

def findBlock(board,key):
    '''Given a point p this function finds all the elements in the
    block containing p,we do a DFS from the point to find all the 
    element in the board storing them in the stack'''
    (i,j)=key[0],key[1]
    color=board[i,j]
    num1=len(board)                     #Dimensions of the board
    num2=board.shape[1]
    explored={}
    explored[(i,j)]=1                   #Mark the point as explored
    neighbours=[]                       #Stack to perform DFS
    members=[]                          #List to store all the points in a block
    neighbours.append((i,j))
    members.append((i,j))
    moves=[(-1,0),(1,0),(0,1),(0,-1)]   #All Possible neighbours of a point
    while not neighbours==[]:
        (x,y)=neighbours.pop(-1)
        for i in moves:
            new_x=x+i[0]
            new_y=y+i[1]
            if -1<new_x<num1 and -1<new_y<num2:
                if board[new_x,new_y]==color and not (new_x,new_y) in explored:
                        neighbours.append((new_x,new_y))
                        members.append((new_x,new_y))
                        explored[(new_x,new_y)]=1
    members.sort(key=lambda x: (x[1],x[0]))
    return members


def eliminate(board,key):
    '''This function is used to blast a bubble block'''
    count=1
    points=findBlock(board,key)     #The function return the list of points sorted by horizontal coordinates
    initial=points[0]
    for i in range(1,len(points)):
        if points[i-1][1]==points[i][1]:                   #If points are of the same column just increase the count by which above elements to be shifted down
            count+=1
        else:
            downshift(initial[0],initial[1],count,board)   #If we find a new horizontal cordinate shift down in the previous horizontal cordinate by count
            count=1
            initial=points[i]
    downshift(initial[0],initial[1],count,board)

    
def evaluatePoint(board,block,explored,i,j):
    '''This function explores all the points which can be a
    part of the block of bubbles from a given point and set them
    explored  and stores the point as reference to the block found'''
    color=board[i,j]
    if color==0 or (i,j) in explored:       #If empty spot or already explored then do nothing
        return 0
    num1=len(board)
    num2=board.shape[1]
    explored[(i,j)]=1                       #Mark the point as explored
    neighbours=[]
    neighbours.append((i,j))                #Stack to store all the points ,required for DFS
    count=0
    a,b=i,j
    moves=[(-1,0),(1,0),(0,1),(0,-1)]       #All possible neighbours of a point 
    while not neighbours==[]:
        (x,y)=neighbours.pop(-1)
        count+=1
        for i in moves:                     #Explores all four neighbours of a given point
            new_x=x+i[0]
            new_y=y+i[1]
            if -1<new_x<num1 and -1<new_y<num2:
                if board[new_x,new_y]==color and not (new_x,new_y) in explored:
                        neighbours.append((new_x,new_y))
                        explored[(new_x,new_y)]=1
    if count<2:
        return 0
    block[(a,b)]=count                  #Store one element of a block along with the numbers of elements corresponding to the point

        
def evaluateBoard(board,block):
    '''This function checks for all the blocks in a board configuration'''
    num1=len(board)             #Dimension of the board
    num2=board.shape[1]
    explored={}
    for i in range(num1):           #This loop calls the exploring function on each point on the board to check for 
        for j in range(num2):
            evaluatePoint(board,block,explored,i,j)


def solve(board):
    '''This function takes as input num1*num2 matrix and select the series of
    bubble to be broken while trying to maximise the score.This function continuously
    breaks the bubble of color which are less frequent and save the more frequent color bubble
    for the end '''
    answer=[]
    sublist=[]
    num1=len(board)            #Dimensions of the Board
    num2=board.shape[1]
    numColor={}                 #Dictionary to store occurence of each color
    totalScore=0
    for i in range(num1):       #This loop calculates the occurence of each color
        for j in range(num2):
            if board[i,j] in numColor:
                numColor[board[i,j]]+=1
            else:
                numColor[board[i,j]]=1
    colors=numColor.keys()
    colors.sort(key = lambda x:numColor[x])         #Colors sorted in the order of their number of occurence
    maximum=len(colors)
    while True:
        i=0
        colorblock=[]
        block={}
        evaluateBoard(board,block)
        while len(colorblock) == 0 and i < maximum : #Continously selects for the color with minimum occurence if it has any block
            for j in block.keys():
                if board[j[0],j[1]]==colors[i]:    
                    colorblock.append(j)
            i+=1
        if i==maximum and len(colorblock)==0: #If no block of any color found then exit the loop
            break
        key=min(colorblock,key =lambda x:block[x])  #Selects the block with minimum size for a given color
        eliminate(board,key)                        #Breaks the selected block
        score=block[key]
        a=(board,score*score)   
        sublist.append(copy.deepcopy(a))            #Appends the board state and the score obtained tuple in the sublist
        totalScore+=score*score                     #Increment total Score
    answer.append(sublist)
    answer.append(totalScore)
    return answer
    
            
