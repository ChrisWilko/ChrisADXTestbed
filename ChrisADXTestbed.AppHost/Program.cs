var builder = DistributedApplication.CreateBuilder(args);

var apiService = builder.AddProject<Projects.ChrisADXTestbed_ApiService>("apiservice");

builder.AddProject<Projects.ChrisADXTestbed_Web>("webfrontend")
    .WithExternalHttpEndpoints()
    .WithReference(apiService);

builder.Build().Run();
