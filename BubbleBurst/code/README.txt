INPUT FORMAT:
The function takes as input a numpy matrix of (m*n) dimension ,in which integers are used to 
represent the colors.The integers 1,2...c represent c colors present in the matrix.


OUTPUT FORMAT:
The output is a list which has two elments :
1.Sublist :0th element of the list ,this is a list of tuples (M1,S1),.(Mi,Si),..(Mk,Sk) 
            where Mi represents the intermediate matrix and Si is the score obtained by 
            formation of this matrix from the previous one.

2.Total Score :The 1th element of the list is total score obtained till the matrix is 
            further irreducible
 Format : [[(M1,S1),.(Mi,Si),..(Mk,Sk) ],totalScore]

In the matrix Mi 0 is used to represent an empty space.
 
 
How to Use function Example:
    import new_bubble
    answer=new_bubble.solve(input_matrix)
    totalScore=answer[1]
    listofstates=answer[0]
    state1=listofstates[0][0]
    state1Score=listofstates[0][1]