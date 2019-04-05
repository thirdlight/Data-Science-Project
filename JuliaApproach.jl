#you only need to run these Pkg.add() once, they will install necessary packages
#Pkg.add("FileIO")
#Pkg.add("QuartzImageIO")   #this is required for Apple machines
#Pkg.add("ImageMagick")
#pkg.add("Images")

using FileIO
#using QuartzImageIO    again, this is only required for Apple machines
using ImageMagick
using Images

#Julia can run terminal commands on your local machine, at least if your running it on your local machine through the Atom IDE
cd("greyscale_images")
pwd()


#numSamples decides how many images are loaded into the matrix.
#I recommend starting with 2 to see how your machine reacts to the workload
#Max allowed is the total number of images. Julia indeces start at 1, not 0
numSamples = 5

#some images are much smaller than others.
#they must be normalized to a size which is equal to or less than the smallest image in the sample, so they can all be put in the same matrix.
sampleSizeX = 2000
sampleSizeY = 2000


imgMatrix = Matrix{Gray{Normed{UInt8,8}}}(undef, numSamples, sampleSizeX*sampleSizeY)
function createMatrix(imgMatrix::Array, numSamples::Int, sampleSizeX::Int, sampleSizeY::Int)
    local i = 1
    for id = 1:344
        if i> numSamples
            break
        end
        for sample = 1:4
            if i > numSamples
                break
            elseif isfile(string("PIL-", id, "_3dayLBCR-", sample, ".jpg"))
                nextImg = load(string("PIL-", id, "_3dayLBCR-", sample, ".jpg"))
                #this next line is taking a sample of the given sample size from the center of the image and adding it to the matrix
                #I figured the very center of the cells are the area of interest
                nextImg = nextImg[Int(floor((size(nextImg,1)/2))-(floor(sampleSizeX/2))):(Int(ceil((size(nextImg,1)/2))+(ceil(sampleSizeX/2))))-1,Int(floor((size(nextImg,2)/2))-(floor(sampleSizeY/2))):(Int(ceil((size(nextImg,2)/2))+(ceil(sampleSizeY/2))))-1]
                nextImgAsAVector = reshape(nextImg, 1, :)
                imgMatrix[i, :] = nextImgAsAVector
                i=i+1
                println(string("PIL-", id, "_3dayLBCR-", sample, ".jpg has been added"))
                println(string("there are now ", i-1, " images in imgMatrix"))
            end
        end
    end
    return imgMatrix
end

imgMatrix = createMatrix(imgMatrix, numSamples, sampleSizeX, sampleSizeY)
#if you encounter an error and want to retry building the imgMatrix, you may have to cleanup your memory
#im not exactly sure this is necessary, or if this is how you do it, but run the next two lines. I think GC is garbage collect.
#imgMatrix=nothing
#GC

#transpose worked for me, but when i try XtX i get OutOfMemoryError()
mt = transpose(imgMatrix)
XtX = mt * imgMatrix

#from here down is scribble, you can ignore this
print(size(imgMatrix))
img[:,:,1] = load("PIL-14_3dayLBCR-2.jpg")

img2 = load("PIL-14_3dayLBCR-4.jpg")

print(sizeof(UInt8))
print(ndims(img))
test2 = test[Int(floor((size(test,1)/2)-1000)):Int(floor(size(test,1)/2)+1000),Int(floor(size(test,2)/2)-1000):Int(floor(size(test,2)/2)+1000)]
test3 = test[Int(floor((size(test,1)/2)-1000)):Int(floor(size(test,1)/2)+1000),Int(floor(size(test,2)/2)-1000):Int(floor(size(test,2)/2)+1000)]

print(img[1,3,3])
print(isfile("PIL-14_3dayLBCR-42.jpg"))
cat()
test = load("PIL-1_3dayLBCR-3.jpg")
img[:,:,3] = img2[1:8760,1:8832]
img = cat(img, img2)
print(Int(floor((size(test,2)/2))-(floor(sampleSizeX/2))))
print(Int(ceil((size(test,1)/2))+(ceil(sampleSizeX/2))))
print(Int(ceil((size(test,1)/2)+(sampleSizeX/2))))
img

a = [1 2 3 4; 5 6 7 8]
print(a)

b = reshape(test3, 1, :)
print(b)

c = reshape(test2, 1, :)

print(c)

Mat = Matrix{Gray{Normed{UInt8,8}}}(undef, 2, 4004001)

Mat[1,:]=b

sizeof(Mat)

Mat[2, :]=c
print(Mat)

Mat[2,2]

Mat[1,221]
