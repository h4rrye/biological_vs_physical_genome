-- Genome Table pre processing --
WITH gt AS (
	WITH pre_pro_gt AS (
		SELECT
			geneId AS gene_id,
			geneName AS geneName,
			start AS gene_start,
			end AS gene_end,
			strand,
			CONCAT ('chr', chr) AS chr,
			IF (strand = -1, end, start) AS TSS,		-- average lenght OF a tss IS 70-500 bp
			IF (strand = 1, end, start) AS TES,
			ABS (start - end) AS gene_length
		FROM functional_physical.genome_table
	)
	SELECT
		*,
		round ((TSS/40000), 0) * 40000 AS tss_bin		-- ALL bins NORMALIZED TO 40kbp
	FROM pre_pro_gt
)
SELECT * FROM gt;


-- gene expression -- 
SELECT 
	g.*,
	e.*
FROM functional_physical.genome_table g
LEFT JOIN functional_physical.gene_expression e ON g.geneName = e.gene;


-- max gene expression --
SELECT 
	g.*,
	m.*,
	IF (g.strand = 1, g.`start`, g.`end`) as tss
FROM functional_physical.genome_table g
LEFT JOIN functional_physical.max_gene_expression m 
	ON CONCAT ('chr',g.chr) = m.chr 
	AND (IF (g.strand = 1, g.`start`, g.`end`) BETWEEN m.coord - 40000 AND m.coord);


-- exxpression breadth --
SELECT 
	g.*,
	b.*
FROM functional_physical.genome_table g
LEFT JOIN functional_physical.expression_breadth b ON g.geneId = b.gene;


-- replication timing --
SELECT 
	 g.*,
	 r.*
FROM functional_physical.genome_table g
LEFT JOIN functional_physical.replication_timing r 
ON CONCAT ('chr', g.chr) = r.chr AND (IF (g.strand = 1, g.`start`, g.`end`) BETWEEN r.coord - 40000 AND r.coord);


-- distance from surface --
SELECT 
	g.*,
	d.dist_from_surf
FROM functional_physical.genome_table g
LEFT JOIN functional_physical.distance_from_surface_chr1 d
ON g.chr = 1 AND (IF(g.strand = 1, g.`start`, g.`end`) BETWEEN d.bin - 20000 AND d.bin)
WHERE g.chr = 1
ORDER BY g.`start`;


-- distance from center of mass --
SELECT 
	g.*,
	c.dist_from_com 
FROM functional_physical.genome_table g
LEFT JOIN functional_physical.dist_from_com_chr1 c 
ON g.chr = 1 AND (IF(g.strand = 1, g.`start`, g.`end`) BETWEEN c.coord - 40000 AND c.coord)
WHERE g.chr = 1;


-- total accessible surface area --
SELECT
	g.*,
	COALESCE (t.total_surface_accessibility_score, 0) AS cc
FROM functional_physical.genome_table g
LEFT JOIN functional_physical.tasa_chr1 t 
ON g.chr=1 AND (IF(g.strand=1,g.`start`,g.`end`) BETWEEN t.genomic_coordinate-100000 AND t.genomic_coordinate)
WHERE g.chr=1;


---------------------------------------------------------------------------------------------------------------------


-- super genome table --
WITH gt AS (
	WITH pre_pro_gt AS (
		SELECT
			geneId AS gene_id,
			geneName AS gene_name,
			start AS gene_start,
			end AS gene_end,
			strand,
			CONCAT ('chr', chr) AS chr,
			IF (strand = -1, end, start) AS TSS,		-- average lenght OF a tss IS 70-500 bp
			IF (strand = 1, end, start) AS TES,
			ABS (start - end) AS gene_length
		FROM functional_physical.genome_table
	)
	SELECT
		*,
		round ((TSS/40000), 0) * 40000 AS tss_bin		-- ALL bins NORMALIZED TO 40kbp
	FROM pre_pro_gt
)
SELECT 
	g.*,
	e.FPKM AS fpkm,
	m.esc_max_exp,
	m.npc_max_exp,
	b.expression_breadth,
	r.repli_NPC AS rep_timing,
	d.dist_from_surf,
	c.dist_from_com,
	COALESCE (t.total_surface_accessibility_score, 0) AS tasa
FROM gt g
LEFT JOIN functional_physical.gene_expression e
ON g.gene_name = e.gene
LEFT JOIN functional_physical.max_gene_expression m
ON g.chr = m.chr
	AND g.TSS BETWEEN m.coord-40000 AND m.coord
LEFT JOIN functional_physical.expression_breadth b
ON g.gene_id = b.gene 
LEFT JOIN functional_physical.replication_timing r
ON g.chr = r.chr
	AND g.TSS BETWEEN r.coord-40000 AND r.coord
LEFT JOIN functional_physical.distance_from_surface_chr1 d
ON g.chr = 'chr1' 
	AND g.TSS BETWEEN d.bin-20000 AND d.bin
LEFT JOIN functional_physical.dist_from_com_chr1 c
ON g.chr = 'chr1'
	AND g.TSS BETWEEN c.coord-40000 AND c.coord
LEFT JOIN functional_physical.tasa_chr1 t
ON g.chr = 'chr1'
	AND g.TSS BETWEEN t.genomic_coordinate-100000 AND t.genomic_coordinate;


