# FUNCTION visual
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
# visual(digits[,1:100],10) 
#
# Last update: 14.03.14 Hugo Gabriel Eyherabide

visual <- function( pictures, cols=0)
{

# Compute the dimensiones of the final figure in units of pictures.

  numpictures=dim(pictures)[2];

  if (cols==0 || !is.numeric(cols)) cols <- floor(sqrt(numpictures))
  else if (cols>numpictures) cols <- numpictures

  rows <- ceiling(numpictures/cols)

# Adding columns with zeros so that the number of pictures in the final figure coincides with the number of pictures in the input matrix.

  if (cols*rows>numpictures) pictures <- cbind(pictures,matrix(rep(0,(rows*cols-numpictures)*dim(pictures)[1]),nrow=dim(pictures)[1]))

# Creating the patches containing each figure. Digits are arranges in row-major order.
  dim(pictures) <- c(28,28,cols,rows)
  pictures <- aperm(pictures,c(1,3,2,4))
  dim(pictures) <- c(28*cols,28*rows)
  
# Creating the figure. The colormap will be inverted so that the background colour is white.
image(pictures[,(28*rows):1], col=gray(256:0/256), axes = FALSE)
  
}
