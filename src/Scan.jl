using StaticArrays

struct Scan{T<:Unsigned}
    data::Array{T,2}
    offset::SVector{2, Int64}
    resolution::SVector{2, Int64} # Pixels per micron, xy
    laser::Int64
    filter::String
end

function Base.view(scan::Scan, idx1, idx2)
    idx1, idx2 = Base.to_indices(scan.data, (idx1, idx2))
    return Scan(
        @view(scan.data[idx1, idx2]),
        offset+[idx[1], idx2[1]]-1,
        scan_resolution,scan.laser, scan.filter)
end

function Base.getindex(scan::Scan, idx1, idx2)
    idx1, idx2 = Base.to_indices(scan.data, (idx1, idx2))
    return Scan(
        scan.data[idx1, idx2],
        offset+[idx[1], idx2[1]]-1,
        scan.resolution, scan.laser, scan.filter)
end

function map_to_pixels(xy_microns::Real)

end

function load_tiff(filepath::AbstractString)
end

