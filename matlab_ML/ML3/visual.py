from pylab import *

def visual(pictures, cols=0):

## FUNCTION visual
#
# Display images stored in the columns of a matrix as a matrix of patches.
#
# pictures:     matrix in which each column represents one picture. Pictures are
#               stored in row-major order.
# cols          number of pictures in the horizontal dimension of the final
#               figure.
#
# EXAMPLE: Display the first 100 digits in a square of 10x10 images.
#
# visual(digits(:,1:100),10) 
#
# Last update: 14.03.14 Hugo Gabriel Eyherabide

    
    # Compute the dimensiones of the final figure in units of pictures.

    numpictures=size(pictures,1)

    if cols<1: 
        cols=ceil(sqrt(numpictures)) 
    elif cols>numpictures:
        cols=numpictures
        
    rows=ceil(numpictures/cols)
    
    # Adding columns with zeros so that the number of pictures in the final
    # figure coincides with the number of pictures in the input matrix.

    pictures=concatenate((pictures,zeros((size(pictures,0),rows*cols-numpictures))),axis=1)
    

    # Creating the patches containing each figure. Digits are arranges in
    # row-major order.

    pictures=reshape(transpose(reshape(pictures,(28,28,cols,rows),order='F'),[1,3,0,2]),(28*rows,28*cols),order='F')


    # Creating the figure. The colormap will be inverted so that the background
    # colour is white.

    imshow(pictures,cmap="gray_r")
    axis('off')
    show() 



