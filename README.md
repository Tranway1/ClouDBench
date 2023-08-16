# ClouDBench (Cloud Database Benchmark)

The ClouDBench project is a collaborative initiative aimed at creating a more realistic analytical benchmark for cloud data warehouses. Traditional benchmarks such as TPC-H/DS often fail to present a realistic picture of the performance of cloud data warehouses, with each service typically showing optimal performance on its native cloud service. To address this, ClouDBench, spearheaded by [MIT DSG](https://dsg.csail.mit.edu/) in collaboration with Amazon, Intel, Meta, Microsoft, and Google, seeks to develop a benchmark that is more representative of real-world workloads.

## Introduction

The ClouDBench project aims to construct a benchmark that comprehensively evaluates the performance of cloud data warehouses by using representative workloads from major cloud database vendors. This open-source initiative will culminate in the publication of a research paper.

## Procedure

- Each participating company will provide 2 to 3 sets of workloads (consisting of timestamped queries, schema, and data), selected based on representative client usage statistics to ensure authenticity and relevance.
- MIT will benchmark all datasets on eligible cloud data warehouses, including potential candidates such as Azure SQL, Snowflake, Databricks, Bigquery, and Redshift.
- The benchmark results, along with the workloads, will be compiled and included in a research paper.
- Each company will be given an opportunity to review the benchmark results and suggest improvements before the paper is published.

## Constraints and Guidelines

The ClouDBench project adheres to the following key constraints and guidelines:

- Legal constraints must be respected at all times.
- The benchmarking process should be kept simple and straightforward.
- The focus should be on the most important workload characteristics, such as temporal aspects, repetitiveness, query complexity, and data properties.
- Workloads should not contain any vendor-specific features.
- The benchmarking process and final results should be easy to understand and compare, avoiding excess metrics and complex benchmarks.

## Contributions and Evaluation

- Participating cloud vendors are required to contribute 1 to 3 representative workloads, along with a justification for their selection, based on key usage statistics.
- The workloads should comply with the given guidelines and not contain any vendor-specific features.
- Each workload will be scrutinized for its representativeness, and MIT reserves the right to exclude workloads deemed inappropriate.
- Following the evaluation of all workloads across multiple cloud services, the performance results will be compiled, including performance for the first run, steady-state performance, etc.

## Review and Publication

- After the initial evaluation, cloud vendors will be given a chance to improve their results and correct any identified errors.
- The results will then be published under generic identifiers such as System-A, System-B for cloud services, and Workload-A, Workload-B for workloads. The associated companies will not be identified.
- The final publication will include an analysis of the differing workloads, cross comparisons, and insights on how these workloads are realistic representations of live workloads.


## folder structure
```
├── README.md       <- The top-level README for developers using this project.
├── workload        <- All workloads provided by cloud vendors.
├── benchmark       <- Benchmarking scripts and results.
├── src             <- Source code for use in this project.
```

## Contact
Chunwei Liu (chunwei@mit.edu)
