# 1.1 Safety
<h2 style="text-align: center">⚠️ Safety First ⚠️</h2>
<p data-start="1380" data-end="1486">Laser engraving isn’t just a casual hobby — it’s a powerful tool that requires care and attention.
Always wear the provided safety goggles and avoid inhaling the smoke produced during engraving.
Safety is the first step to enjoying your laser engraver with peace of mind.</p>

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
<div class="product-grid">
<!-- Produit 1 -->
<div class="product-item2">
<a href="https://wanhao-europe.com/collections/yumi-acmer-les-2-gammes-completes/products/plateau-de-travail-honey-comb-pour-laser-yumi-l-a4-l-a3?variant=50422470213972" rel="noopener noreferrer" target="_blank"> <img src="https://i.ibb.co/VtBS4ss/YLA4-HONEYCOMB400-X400.jpg" alt="Honeycomb"> </a>
<div class="product-title"><strong>Honeycomb</strong></div>
<div class="product-title">For cleaner, safer engraving results.</div>
</div>
<!-- Produit 2 -->
<div class="product-item2">
<a href="https://wanhao-europe.com/collections/yumi-acmer-les-2-gammes-completes/products/enclos-de-protection-pour-laser-yumi-l-a4-l-a3" rel="noopener noreferrer" target="_blank"> <img src="https://i.ibb.co/d2ytjBv/YUMLENCLOBOX-11.jpg" alt="Enclosure - Extracteur d’air"> </a>
<div class="product-title"><strong>Enclosure + Air Extractor</strong></div>
<div class="product-title">Prevents smoke inhalation.</div>
</div>
<!-- Produit 3 - Lunettes -->
<div class="product-item2">
<a rel="noopener" title="laser ymui l-a4" href="https://wanhao-europe.com/collections/yumi-graveur-laser/products/yumi-l-a4-laser-pour-gravure-et-decoupe-pre-commande" target="_blank"><img src="https://i.ibb.co/K3F5QW2/lunette.jpg" alt="Lunettes de protection laser"></a>
<div class="product-title"><strong>Protective Glasses</strong></div>
<div class="product-title">Included with your Yumi L-A4 laser.</div>
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