# 1.2 Laser GRBL

<style>

.product-grid {
  display: flex;
  justify-content: center;
  align-items: flex-start;
  gap: 40px;
  margin: 40px auto;
  max-width: 1300px;
  text-align: center;
  flex-wrap: wrap;
}

.product-item1 {
  width: 280px;
  display: flex;
  flex-direction: column;
  align-items: center;
  position: relative;
}

/* Image */
.product-item1 img {
  width: 100%;
  border-radius: 10px;
  transition: transform 0.3s ease;
  box-shadow: 0 2px 10px rgba(0,0,0,0.1);
  cursor: zoom-in;
}
  

/* Effet hover */
.product-item1 img:hover {
  transform: scale(1.05);
}

  .product-item2 {
  width: 280px;
  display: flex;
  flex-direction: column;
  align-items: center;
  position: relative;
}

/* Image */
.product-item2 img {
  width: 100%;
  border-radius: 10px;
  transition: transform 0.3s ease;
  box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}
  

/* Effet hover */
.product-item2 img:hover {
  transform: scale(1.05);
  cursor: pointer;
}



/* Titre */
.product-title {
  margin-top: 10px;
  font-size: 15px;
  font-weight: 600;
  line-height: 1.4;
}

/* === Lightbox universelle === */
#zoom-viewer {
  display: none;
  position: fixed;
  inset: 0;
  background: rgba(0,0,0,0.85);
  justify-content: center;
  align-items: center;
  z-index: 9999;
  cursor: zoom-out;
  animation: fadeIn 0.3s ease;
}

/* Image zoomée */
#zoom-viewer img {
  max-width: 90%;
  max-height: 90%;
  border-radius: 10px;
  box-shadow: 0 0 25px rgba(0,0,0,0.6);
  object-fit: contain; /* ✅ garde les proportions originales */
  width: auto;
  height: auto;
  transform: scale(1);
  transition: transform 0.25s ease;
}

/* Apparition fluide */
@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

/* Responsive */
@media (max-width: 1200px) {
  .product-item1 { width: 45%; }
}
@media (max-width: 700px) {
  .product-item1 { width: 90%; }
}
</style>


<h2 style="text-align: center;" data-end="1025" data-start="975">LaserGRBL: Free, Powerful, and Easy to Use</h2>

<style>
.lasergrbl-container {
  display: flex;
  justify-content: center; /* centre le bloc dans la page */
  width: 100%;
}

.lasergrbl-row {
  display: flex;
  align-items: center;
  gap: 60px; /* plus grand espace entre image et texte */
  max-width: 900px;
  margin: 40px auto;
  text-align: left;
}

.lasergrbl-row img {
  width: 350px; /* taille augmentée de 25% (avant 280px) */
  height: auto;
  border-radius: 10px;
  flex-shrink: 0;
  display: block;
  object-fit: cover;
}

.lasergrbl-text {
  flex: 1;
  line-height: 1.6;
}

.lasergrbl-text h3 {
  margin-top: 0;
}

.lasergrbl-text ul {
  text-align: left;
  list-style: none; 
  padding-left: 20px;
  margin: 10px 0;
}

.lasergrbl-text li {
  margin-bottom: 8px;
}

/* Responsive : image au-dessus sur mobile */
@media (max-width: 768px) {
  .lasergrbl-row {
    flex-direction: column;
    align-items: center;
    gap: 20px; /* réduit sur mobile */
  }
  

  .lasergrbl-text {
    max-width: 90%;
  }

  .lasergrbl-row img {
    width: 80%; /* image s’adapte sur mobile */
    
  }
}
</style>
<div class="lasergrbl-container">
<div class="lasergrbl-row">
<a title="laser grbl" href="https://lasergrbl.com/download/" rel="noopener noreferrer" target="_blank"><img src="https://i.ibb.co/rRkXRMg2/Laser-BRGL005.jpg" alt="LaserGRBL logiciel gratuit"></a>
<div class="lasergrbl-text">
<p>Unlike many expensive engraving programs, LaserGRBL is:</p>
<ul>
<li>✅ Free and open-source</li>
<li>✅ Compatible with the Yumi L-A4</li>
<li>✅ User-friendly</li>
<li>✅ Supports multiple file formats (JPG, PNG, SVG...)</li>
</ul>
<p>👉 The perfect choice to get started without investing in paid software.</p>
</div>
</div>
</div>
<h2 style="text-align: center;" data-start="1856" data-end="1900">Prepare and Test Your Engraving</h2>

<div class="product-grid">
<!-- Produit 1 -->
<div class="product-item2">
<a href="https://lasergrbl.com/download/"> <img src="https://i.ibb.co/WvfWqxs7/grbl.jpg" alt="Honeycomb"> </a>
<div class="product-title">
<p style="text-decoration: underline;"><a rel="noopener" title="laser grbl" href="https://lasergrbl.com/download/" target="_blank">Download and install LaserGRBL, then connect your Yumi L-A4 to your PC.</div>
</div>
<!-- Produit 2 -->
<div class="product-item1">
<a href="#zoom-viewer"> <img src="https://i.ibb.co/S4HBw6bw/calibration.jpg" alt="liege"> </a>
<div class="product-title">
<p>Place your material and adjust the laser head height using the included guide.</p>
</div>
</div>
<!-- Produit 3 - Lunettes -->
<div class="product-item1">
<a href="#zoom-viewer"><img src="https://i.ibb.co/60TH4Y6D/connecter.jpg" alt="Lunettes de protection laser"></a>
<div class="product-title">
<p>Connect the Yumi L-A4 and run a test engraving.</p>
</div>
</div>
<div class="product-item1">
<a href="#zoom-viewer"><img src="https://i.ibb.co/cXhZxw4P/test.jpg" alt="Lunettes de protection laser"></a>
<div class="product-title">
<p data-start="2070" data-end="2105">Perform a burn test.</p>
</div>
</div>
</div>
<div class="product-grid">
<!-- Produit 1 -->
<div class="product-item1">
<a href="#zoom-viewer"> <img src="https://i.ibb.co/v4J0WLzn/test2.jpg" alt="Honeycomb"> </a>
<div class="product-title">
<p>Adjust the size based on your material (in mm).</p>
</div>
</div>
<!-- Produit 2 -->
<div class="product-item1">
<a href="#zoom-viewer"> <img src="https://i.ibb.co/LXRSRP7f/placer-tete.jpg" alt="liege"> </a>
<div class="product-title">
<p>Position the laser head so it starts from the bottom-left corner of the engraving area.</p>
</div>
</div>
<!-- Produit 1 -->
<div class="product-item1">
<a href="#zoom-viewer"> <img src="https://i.ibb.co/1fJ7Twvw/lancertest.jpg" alt="Honeycomb"> </a>
<div class="product-title">
<p>Start the test engraving.</p>
</div>
</div>
<!-- Produit 2 -->
<div class="product-item1">
<a href="#zoom-viewer"> <img src="https://i.ibb.co/pj57LxL4/test3.jpg" alt="liege"> </a>
<div class="product-title">
<p>The ideal settings produce a black, clean, and even engraving — without burning or digging into the material. Keep notes of your best parameters for future projects..</p>
</div>
</div>
</div>

<div id="zoom-viewer" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%;
background:rgba(0,0,0,0.85); justify-content:center; align-items:center; z-index:9999; cursor:zoom-out;">
  <img src="" alt="Zoom image" style="max-width:90%; max-height:90%; border-radius:10px; box-shadow:0 0 25px rgba(0,0,0,0.6); object-fit:contain;">
</div>

<script>
const zoomViewer = document.getElementById('zoom-viewer');
const zoomImg = zoomViewer.querySelector('img');
const scrollPos = { top: 0, left: 0 };

// Ouvrir le zoom
document.addEventListener('click', e => {
  const img = e.target.closest('.product-item1 img');
  if (!img) return;
  e.preventDefault();
  scrollPos.top = window.scrollY;
  scrollPos.left = window.scrollX;
  zoomImg.src = img.src;
  zoomViewer.style.display = 'flex';
  document.body.style.overflow = 'hidden';
});

// Fermer le zoom
zoomViewer.addEventListener('click', () => {
  zoomViewer.style.display = 'none';
  document.body.style.overflow = '';
  window.scrollTo(scrollPos.left, scrollPos.top);
});

</script>