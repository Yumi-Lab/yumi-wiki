# 1.09 YUMI L-A4 — Default GRBL Parameters

Ce tableau regroupe les paramètres GRBL par défaut du **YUMI L-A4**.  
Ordre des colonnes : **Code | Parameter | Default Value | Unit | Description** (Parameter en 2ᵉ colonne).

| **Code** | **Parameter**                          | **Default Value** | **Unit**       | **Description** |
|---------:|----------------------------------------|-------------------:|----------------|-----------------|
| $0       | Step pulse time                        | 10                 | microseconds   | Durée d’un front d’impulsion de pas. Min 3 µs. |
| $1       | Step idle delay                        | 5                  | milliseconds   | Maintien court des moteurs à l’arrêt avant désactivation (255 = toujours activés). |
| $2       | Step pulse invert                      | 0                  | mask           | Inversion du signal STEP. Bit par axe (00000ZYX). |
| $3       | Step direction invert                  | 0                  | mask           | Inversion du signal DIR. Bit par axe (00000ZYX). |
| $4       | Invert step enable pin                 | 0                  | boolean        | Inverse le niveau logique de EN des drivers. |
| $5       | Invert limit pins                      | 0                  | boolean        | Inverse l’état des entrées de fin de course. |
| $6       | Invert probe pin                       | 0                  | boolean        | Inverse l’entrée de palpeur. |
| $10      | Status report options                  | 1                  | mask           | Sélection des infos renvoyées dans les statuts. |
| $11      | Junction deviation                     | 0.010              | mm             | Douceur de passage entre segments successifs (plus petit = plus lent). |
| $12      | Arc tolerance                          | 0.002              | mm             | Tolérance des arcs G2/G3 (erreur radiale). |
| $13      | Report in inches                       | 0                  | boolean        | Rapports de position en pouces (si 1). |
| $20      | Soft limits enable                     | 0                  | boolean        | Limites logicielles (nécessite homing). |
| $21      | Hard limits enable                     | 1                  | boolean        | Limites matérielles (arrêt immédiat sur déclenchement). |
| $22      | Homing cycle enable                    | 1                  | boolean        | Active la séquence de référencement (homing). |
| $23      | Homing direction invert                | 3                  | mask           | Inverse la direction de recherche par axe (00000ZYX). |
| $24      | Homing locate feed rate                | 300.000            | mm/min         | Avance lente pour l’appui précis sur le switch. |
| $25      | Homing search seek rate                | 3000.000           | mm/min         | Vitesse de recherche rapide des switches. |
| $26      | Homing switch debounce delay           | 250.000            | milliseconds   | Anti-rebond entre phases de homing. |
| $27      | Homing switch pull-off distance        | 1.000              | mm             | Recul après déclenchement pour libérer le switch. |
| $28      | —                                      | 1000.000           | —              | Réservé / spécifique firmware (non documenté ici). |
| $30      | Maximum spindle speed                  | 1000.000           | RPM            | Vitesse broche max (PWM = 100%). |
| $31      | Minimum spindle speed                  | 0.000              | RPM            | Vitesse broche min (PWM ~0.4% ou min). |
| $32      | Laser-mode enable                      | 1                  | boolean        | Mode laser (pas d’arrêt entre G1/2/3 lors des modifs de S). |
| $37      | —                                      | 1                  | —              | Réservé / spécifique firmware (non documenté ici). |
| $38      | —                                      | 1                  | —              | Réservé / spécifique firmware (non documenté ici). |
| $40      | —                                      | 1                  | —              | Réservé / spécifique firmware (non documenté ici). |
| $100     | X-axis travel resolution               | 80.000             | steps/mm       | Résolution X en pas par mm. |
| $101     | Y-axis travel resolution               | 80.000             | steps/mm       | Résolution Y en pas par mm. |
| $102     | Z-axis travel resolution               | 80.000             | steps/mm       | Résolution Z en pas par mm. |
| $103     | A-axis travel resolution               | 100.000            | steps/mm       | Résolution A en pas par mm. |
| $104     | B-axis travel resolution               | 100.000            | steps/mm       | Résolution B en pas par mm. |
| $105     | C-axis travel resolution               | 100.000            | steps/mm       | Résolution C en pas par mm. |
| $110     | X-axis maximum rate                    | 6000.000           | mm/min         | Vitesse rapide (G0) max de X. |
| $111     | Y-axis maximum rate                    | 6000.000           | mm/min         | Vitesse rapide (G0) max de Y. |
| $112     | Z-axis maximum rate                    | 6000.000           | mm/min         | Vitesse rapide (G0) max de Z. |
| $113     | A-axis maximum rate                    | 1000.000           | mm/min         | Vitesse rapide (G0) max de A. |
| $114     | B-axis maximum rate                    | 1000.000           | mm/min         | Vitesse rapide (G0) max de B. |
| $115     | C-axis maximum rate                    | 1000.000           | mm/min         | Vitesse rapide (G0) max de C. |
| $120     | X-axis acceleration                    | 500.000            | mm/sec^2       | Accélération X (planification). |
| $121     | Y-axis acceleration                    | 500.000            | mm/sec^2       | Accélération Y (planification). |
| $122     | Z-axis acceleration                    | 500.000            | mm/sec^2       | Accélération Z (planification). |
| $123     | A-axis acceleration                    | 200.000            | mm/sec^2       | Accélération A (planification). |
| $124     | B-axis acceleration                    | 200.000            | mm/sec^2       | Accélération B (planification). |
| $125     | C-axis acceleration                    | 200.000            | mm/sec^2       | Accélération C (planification). |
| $130     | X-axis maximum travel                  | 210.000            | mm             | Course utile X (soft-limits & homing). |
| $131     | Y-axis maximum travel                  | 297.000            | mm             | Course utile Y (soft-limits & homing). |
| $132     | Z-axis maximum travel                  | 80.000             | mm             | Course utile Z (soft-limits & homing). |
| $133     | A-axis maximum travel                  | 300.000            | mm             | Course utile A. |
| $134     | B-axis maximum travel                  | 300.000            | mm             | Course utile B. |
| $135     | C-axis maximum travel                  | 300.000            | mm             | Course utile C. |
