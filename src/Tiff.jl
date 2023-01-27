open_tif(path) = ccall((:TIFFOpen, lt), Ptr{Cvoid}, (Cstring, Cstring), path, "r")
close_tif(tif) = ccall((:TIFFClose, lt), Cvoid, (Ptr{Cvoid},), tif)
read_directory(tif) = ccall((:TIFFReadDirectory, lt), Cint, (Ptr{Cvoid},), tif)
set_directory(tif, n) = ccall((:TIFFSetDirectory, lt), Cint, (Ptr{Cvoid}, Cint), tif, n-1)
get_field(tif, n, out) = ccall((:TIFFGetField, lt), Cint, (Ptr{Cvoid}, Cint, Ptr{Cuint}), tif, n, out)
get_string_field(tif, n, out) = ccall((:TIFFGetField, lt), Cint, (Ptr{Cvoid}, Cint, Ptr{Cstring}), tif, n, out)

function get_field(tif::Ptr{Cvoid}, field::Cint, T::Type)
    pt = convert(Ptr{T}, Libc.malloc(sizeof(T)))
    n = ccall((:TIFFGetField, tif), Cint, (Ptr{Cvoid}, Cint, Ptr{T}), tif, field, pt)
    if n != 1
        return 0
    

function load_tif(path::AbstractString)
    file = open_tif(path)
    try
        pint = convert(Ptr{Cuint}, Libc.malloc(sizeof(Cuint)))
        pstring = convert(Ptr{Cstring}, Libc.malloc(sizeof(Cstring)))
        
        dir_count::Int32 = 0
        success::Int32 = 1
        
        while success==1
            dir_count += 1
            println("Read directory")
            get_field(file, 256, pint)
            imwidth = Int64(unsafe_load(pint))
            get_field(file, 257, pint)
            imlength = Int64(unsafe_load(pint))
            println((imwidth, imlength))
            println(get_field(file, 272, pstring))
            artist = unsafe_string(unsafe_load(pstring))
            println(artist)
            success = read_directory(file)
        end
        println(dir_count)
    catch e
        println("Caught error")
        close_tif(file)
        throw(e)
    end
    Libc.free(pint)
    Libc.free(pstring)
    close_tif(file)
end
