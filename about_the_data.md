## About the data

The **`genome_table_mapped.csv`** file contains detailed information about mouse genes, combining both genetic attributes and 3D spatial characteristics derived from prior research. This dataset was generated in a previous project using MySQL.

### Column Descriptions

1. **`gene_id`**  
   - **Definition**: Ensembl gene ID, a universal identifier for genes.  
   - **Purpose**: Ensures consistent and standardized gene representation across datasets.  

2. **`gene_name`**  
   - **Definition**: Standardized gene name.  
   - **Purpose**: Provides a human-readable reference for each gene.  

3. **`gene_start`**  
   - **Definition**: Start position of the gene in base pairs (bp) on its chromosome.  

4. **`gene_end`**  
   - **Definition**: End position of the gene in bp.  

5. **`strand`**  
   - **Definition**: Indicates the DNA strand where the gene is located.  
     - `+1`: Positive strand.  
     - `-1`: Negative strand.  
   - **Purpose**: Crucial for understanding gene transcription orientation.  

6. **`chr`**  
   - **Definition**: Chromosome on which the gene resides.  

7. **`TSS` (Transcription Start Site)**  
   - **Definition**: The site where transcription of the gene begins.  
   - **Special Case**: Equal to `gene_start` for positive strands and `gene_end` for negative strands.  

8. **`TES` (Transcription End Site)**  
   - **Definition**: The site where transcription of the gene ends.  
   - **Special Case**: Equal to `gene_end` for positive strands and `gene_start` for negative strands.  

9. **`gene_length`**  
   - **Definition**: Length of the gene, calculated as the absolute value of `gene_end - gene_start`.  

10. **`tss_bin`**  
    - **Definition**: Transcription Start Site binned at a 40kb resolution.  
    - **Purpose**: Maps physical attributes to regions of interest.  

11. **`fpkm` (Fragments Per Kilobase of transcript per Million mapped reads)**  
    - **Definition**: A measure of gene expression.  

12. **`esc_max_exp`**  
    - **Definition**: Maximum expression level of the gene in mouse Embryonic Stem Cells.  

13. **`npc_max_exp`**  
    - **Definition**: Maximum expression level of the gene in Neural Progenitor Cells.  

14. **`expression_breadth`**  
    - **Definition**: The number of cell types in which the gene is expressed.  
    - **Purpose**: Indicates the functional versatility of the gene.  

15. **`rep_timing`**  
    - **Definition**: The replication timing of the gene, describing its transcription phase.  

16. **`dist_from_surf`**  
    - **Definition**: Distance of the gene from the surface of the chromosome.  
    - **Purpose**: Suggests the gene’s spatial positioning within the chromosome.  

17. **`dist_from_com`**  
    - **Definition**: Distance of the gene from the chromosome’s Center of Mass.  
    - **Purpose**: Another measure of the gene's 3D spatial localization.  

18. **`tasa` (Total Accessible Surface Area)**  
    - **Definition**: Accessibility of the gene, calculated using the Total Accessible Surface Area algorithm.  
    - **Purpose**: Indicates whether the gene is accessible to cellular machinery.  

