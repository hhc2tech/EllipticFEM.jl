
include("../../src/EquationData/equationData.jl")
include("../../src/GeoData/geoData.jl")
include("../../src/MeshData/meshData.jl")
include("../../src/EquationData to GeoData to MeshData/equationDataToGeoData.jl")
include("../../src/EquationData to GeoData to MeshData/geoDataToMeshData.jl")
include("../../src/LSEData/lseData.jl")
include("../../src/Miscellaneous/miscellaneous.jl")
include("../../src/InfoData/infoData.jl")

##############################################

infoDataProcessesStopwatches = Array{ProcessStopwatch,1}(0)
tic()

##############################################

println("Assemble equationData...")
tic()
equationData = equationDataAssemble("./ellipticEquationDataLPipe.jl")
push!(infoDataProcessesStopwatches,ProcessStopwatch(-1,"Assemble equationData",toq(),true))

##############################################

println("Assemble geoData...")
tic()
geoData = equationDataToGeoData(equationData)
push!(infoDataProcessesStopwatches,ProcessStopwatch(-1,"Assemble geoData",toq(),true))

##############################################

println("Plot geoData...")
tic()
# geoDataDisplay(geoData)
geoDataPlot(geoData)
push!(infoDataProcessesStopwatches,ProcessStopwatch(-1,"Plot geoData",toq(),true))

##############################################

intendedMeshsize = 0.02

println("Assemble meshData...")
tic()
meshData = geoDataToMeshData(geoData,intendedMeshsize)
push!(infoDataProcessesStopwatches,ProcessStopwatch(-1,"Assemble meshData",toq(),true))

##############################################

println("Plot meshData...")
tic()
# displayMeshData(meshData)
if intendedMeshsize >= 0.15
	meshDataPlotSlow(meshData)
else
	meshDataPlot(meshData)
end
push!(infoDataProcessesStopwatches,ProcessStopwatch(-1,"Plot meshData",toq(),true))

##############################################

deltaT = 0.0

println("Assemble lseData...")
tic()
lseData = lseDataAssemble(equationData,meshData,deltaT)
push!(infoDataProcessesStopwatches,ProcessStopwatch(-1,"Assemble lseData",toq(),true))

##############################################

println("Solve lseData...")
tic()
lseDataSolve(equationData,meshData,lseData)
push!(infoDataProcessesStopwatches,ProcessStopwatch(-1,"Solve lseData",toq(),true))

##############################################

println("Plot lseData...")
tic()
lseDataPlot(meshData,lseData)
push!(infoDataProcessesStopwatches,ProcessStopwatch(-1,"Plot lseData",toq(),true))

##############################################

push!(infoDataProcessesStopwatches,ProcessStopwatch(-1,"Total",toq(),true))

##############################################

infoData = infoDataAssemble(infoDataProcessesStopwatches,meshData,lseData)
infoDataDisplay(infoData)



