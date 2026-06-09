{{ config(materialized='table') }}

WITH ventes_vendeurs AS (
    SELECT 
        vendeur,
        COUNT(*) AS total_transactions,
        SUM(montant_fcfa) AS chiffre_affaires_total,
        SUM(marge_fcfa) AS marge_totale
    FROM {{ source('supabase', 'faits_ventes_clean') }}
    GROUP BY vendeur
)

SELECT 
    vendeur,
    total_transactions,
    chiffre_affaires_total,
    marge_totale,
    RANK() OVER (ORDER BY chiffre_affaires_total DESC) AS rang_vendeur
FROM ventes_vendeurs
