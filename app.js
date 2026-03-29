const products = [
  {
    id: 1,
    name: "Lumina Pro Wireless Headphones",
    category: "Audio",
    price: 349.00,
    rating: 4.9,
    reviews: 124,
    description: "Experience premium sound with Lumina Pro. Advanced active noise cancellation, 40-hour battery life, and ultra-soft memory foam ear cushions.",
    image: "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=1200",
    badge: "Best Seller"
  },
  {
    id: 2,
    name: "Stealth Titanium Smartwatch",
    category: "Wearables",
    price: 199.00,
    rating: 4.7,
    reviews: 89,
    description: "A blend of luxury and tech. Featuring a sapphire crystal display, titanium body, and full fitness ecosystem integration.",
    image: "https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=1200",
    badge: "Limited"
  },
  {
    id: 3,
    name: "Aura Minimalist Table Lamp",
    category: "Home",
    price: 79.00,
    rating: 4.8,
    reviews: 56,
    description: "Sleek, atmospheric, and smart. The Aura lamp offers dynamic color temperatures and integrated wireless charging for your devices.",
    image: "https://images.unsplash.com/photo-1507473885765-e6ed057f782c?q=80&w=1200",
    badge: "New"
  },
  {
    id: 4,
    name: "Nomad Matte Black DSLR",
    category: "Electronics",
    price: 899.00,
    rating: 4.6,
    reviews: 42,
    description: "Capture life's moments in stunning clarity. Modern mirrorless tech in a rugged, minimalist matte black body.",
    image: "https://images.unsplash.com/photo-1516035069371-29a1b244cc32?q=80&w=1200",
    badge: "Premium"
  },
  {
    id: 5,
    name: "Sonic H1 Bluetooth Speaker",
    category: "Audio",
    price: 129.00,
    rating: 4.7,
    reviews: 156,
    description: "Compact size, legendary sound. 360-degree audio that fills any room, with a waterproof design for any adventure.",
    image: "https://images.unsplash.com/photo-1589003077984-894e133dabab?q=80&w=1200",
    badge: "Popular"
  },
  {
    id: 6,
    name: "Kinetics Ergonomic Keyboard",
    category: "Accessories",
    price: 149.00,
    rating: 4.9,
    reviews: 28,
    description: "Designed for ultimate productivity and comfort. Mechanical switches with a premium aluminum layout and customizable RGB backlight.",
    image: "https://images.unsplash.com/photo-1511467687858-23d96c32e4ae?q=80&w=1200",
    badge: "Designer's Choice"
  }
];

let cart = [];

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    renderFeaturedProducts();
    renderFullProductGrid();
    updateCartUI();
    
    // Smooth scroll to top when changing pages
    window.scrollTo({ top: 0, behavior: 'smooth' });
});

// Navigation System
function showPage(pageId) {
    const sections = document.querySelectorAll('.page-section');
    sections.forEach(sec => sec.classList.add('hidden'));
    
    const targetSection = document.getElementById(`${pageId}-page`);
    if (targetSection) {
        targetSection.classList.remove('hidden');
    }
    
    // Special initializations
    if (pageId === 'cart') renderCartItems();
    
    window.scrollTo({ top: 0, behavior: 'smooth' });
}

// Rendering Logic
function renderFeaturedProducts() {
    const container = document.getElementById('featured-products');
    if (!container) return;
    
    const featured = products.slice(0, 3);
    container.innerHTML = featured.map(p => createProductCard(p)).join('');
}

function renderFullProductGrid() {
    const container = document.getElementById('full-product-grid');
    if (!container) return;
    
    container.innerHTML = products.map(p => createProductCard(p)).join('');
}

function createProductCard(p) {
    return `
        <div class="product-card">
            <div class="product-img-wrapper" onclick="showProductDetail(${p.id})">
                <img src="${p.image}" alt="${p.name}">
                ${p.badge ? `<span class="product-badge">${p.badge}</span>` : ''}
                <button class="wishlist-btn"><i class="far fa-heart"></i></button>
            </div>
            <div class="product-info">
                <p class="product-category">${p.category}</p>
                <h3 class="product-title" onclick="showProductDetail(${p.id})">${p.name}</h3>
                <div class="product-rating">
                    ${getRatingStars(p.rating)}
                    <span>(${p.reviews})</span>
                </div>
                <div class="product-footer">
                    <span class="product-price">$${p.price.toFixed(2)}</span>
                    <button class="add-cart-btn" onclick="addToCart(${p.id})"><i class="fas fa-plus"></i></button>
                </div>
            </div>
        </div>
    `;
}

function getRatingStars(rating) {
    let stars = '';
    for (let i = 1; i <= 5; i++) {
        if (i <= Math.floor(rating)) {
            stars += '<i class="fas fa-star"></i>';
        } else if (i - 0.5 <= rating) {
            stars += '<i class="fas fa-star-half-alt"></i>';
        } else {
            stars += '<i class="far fa-star"></i>';
        }
    }
    return stars;
}

// Product Detail Logic
function showProductDetail(id) {
    const p = products.find(prod => prod.id === id);
    if (!p) return;
    
    const container = document.getElementById('product-detail-content');
    container.innerHTML = `
        <div class="detail-gallery">
            <img src="${p.image}" alt="${p.name}">
        </div>
        <div class="detail-info">
            <span class="product-badge" style="position: static; margin-bottom: 1rem; display: inline-block;">${p.category}</span>
            <h1>${p.name}</h1>
            <div class="product-rating" style="margin-bottom: 1.5rem; font-size: 1.125rem;">
                ${getRatingStars(p.rating)}
                <span>${p.rating} (${p.reviews} Verified Reviews)</span>
            </div>
            <div class="detail-price">$${p.price.toFixed(2)}</div>
            <p class="detail-description">${p.description}</p>
            
            <div style="margin-bottom: 2rem;">
                <h4 style="margin-bottom: 0.5rem;">Select Color</h4>
                <div style="display: flex; gap: 0.5rem;">
                    <div style="width: 30px; height: 30px; border-radius: 50%; background: #000; cursor: pointer; border: 2px solid var(--primary);"></div>
                    <div style="width: 30px; height: 30px; border-radius: 50%; background: #64748b; cursor: pointer;"></div>
                    <div style="width: 30px; height: 30px; border-radius: 50%; background: #e2e8f0; cursor: pointer;"></div>
                </div>
            </div>

            <div class="detail-actions">
                <button class="btn btn-primary" style="flex: 1; justify-content: center; padding: 1rem;" onclick="addToCart(${p.id})">Add to Cart</button>
                <button class="btn" style="border: 1px solid var(--border); padding: 1rem;"><i class="far fa-heart"></i></button>
            </div>
            
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; text-align: center; color: var(--text-muted); font-size: 0.875rem;">
                <div style="padding: 1rem; background: var(--bg-subtle); border-radius: var(--radius-md);">
                    <i class="fas fa-truck" style="margin-bottom: 0.5rem; display: block;"></i> Free Fast Delivery
                </div>
                <div style="padding: 1rem; background: var(--bg-subtle); border-radius: var(--radius-md);">
                    <i class="fas fa-undo" style="margin-bottom: 0.5rem; display: block;"></i> 30-Day Returns
                </div>
            </div>
        </div>
    `;
    
    showPage('detail');
}

// Cart Logic
function addToCart(id) {
    const p = products.find(prod => prod.id === id);
    const existing = cart.find(item => item.id === id);
    
    if (existing) {
        existing.quantity += 1;
    } else {
        cart.push({ ...p, quantity: 1 });
    }
    
    updateCartUI();
    showToast(`${p.name} added to cart!`);
}

function updateCartUI() {
    const count = cart.reduce((sum, item) => sum + item.quantity, 0);
    document.getElementById('cart-count').innerText = count;
}

function renderCartItems() {
    const container = document.getElementById('cart-items-container');
    if (cart.length === 0) {
        container.innerHTML = `
            <div style="text-align: center; padding: 3rem 0;">
                <i class="fas fa-shopping-basket" style="font-size: 4rem; color: var(--border); margin-bottom: 1.5rem;"></i>
                <h2>Your cart is empty</h2>
                <p style="color: var(--text-muted); margin-bottom: 2rem;">Looks like you haven't added anything yet.</p>
                <div class="hero-btns">
                  <button class="btn btn-primary" onclick="showPage('shop')">Shop Collection <i class="fas fa-arrow-right"></i></button>
                </div>
            </div>
        `;
        updateSummary(0);
        return;
    }
    
    container.innerHTML = cart.map(item => `
        <div class="cart-item">
            <img src="${item.image}" alt="${item.name}">
            <div class="cart-item-info">
                <h4 style="font-size: 1.125rem; margin-bottom: 0.25rem;">${item.name}</h4>
                <p style="color: var(--text-muted); margin-bottom: 1rem;">${item.category}</p>
                <div style="font-weight: 700;">$${item.price.toFixed(2)}</div>
            </div>
            <div style="text-align: right;">
                <div style="display: flex; align-items: center; gap: 1rem; margin-bottom: 1rem; border: 1px solid var(--border); padding: 5px 10px; border-radius: var(--radius-md);">
                    <button onclick="changeQuantity(${item.id}, -1)"><i class="fas fa-minus"></i></button>
                    <span>${item.quantity}</span>
                    <button onclick="changeQuantity(${item.id}, 1)"><i class="fas fa-plus"></i></button>
                </div>
                <button style="color: #ef4444;" onclick="removeFromCart(${item.id})"><i class="far fa-trash-alt"></i></button>
            </div>
        </div>
    `).join('');
    
    const subtotal = cart.reduce((sum, item) => sum + (item.price * item.quantity), 0);
    updateSummary(subtotal);
}

function changeQuantity(id, delta) {
    const item = cart.find(i => i.id === id);
    if (!item) return;
    
    item.quantity += delta;
    if (item.quantity < 1) {
        removeFromCart(id);
    } else {
        renderCartItems();
        updateCartUI();
    }
}

function removeFromCart(id) {
    cart = cart.filter(item => item.id !== id);
    renderCartItems();
    updateCartUI();
}

function updateSummary(subtotal) {
    const tax = subtotal * 0.08;
    const total = subtotal + tax;
    
    document.getElementById('summary-subtotal').innerText = `$${subtotal.toFixed(2)}`;
    document.getElementById('summary-tax').innerText = `$${tax.toFixed(2)}`;
    document.getElementById('summary-total').innerText = `$${total.toFixed(2)}`;
}

// Checkout Logic
function handleCheckout(e) {
    e.preventDefault();
    // Simulate order processing
    const btn = e.target.querySelector('button');
    const originalText = btn.innerHTML;
    btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';
    btn.disabled = true;
    
    setTimeout(() => {
        cart = [];
        updateCartUI();
        showPage('confirmation');
    }, 1500);
}

// UI Utilities
function showToast(message) {
    const toast = document.createElement('div');
    toast.className = 'toast';
    toast.style.cssText = `
        position: fixed;
        bottom: 2rem;
        right: 2rem;
        background: #1e293b;
        color: #fff;
        padding: 1rem 2rem;
        border-radius: var(--radius-md);
        box-shadow: var(--card-shadow-hover);
        z-index: 2000;
        animation: slideIn 0.3s ease-out;
    `;
    toast.innerHTML = `<i class="fas fa-check-circle" style="color: #22c55e; margin-right: 0.5rem;"></i> ${message}`;
    document.body.appendChild(toast);
    
    setTimeout(() => {
        toast.style.animation = 'slideOut 0.3s ease-in forwards';
        setTimeout(() => toast.remove(), 300);
    }, 3000);
}

// Keyframe addition
const style = document.createElement('style');
style.innerHTML = `
    @keyframes slideIn { from { transform: translateX(100%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
    @keyframes slideOut { from { transform: translateX(0); opacity: 1; } to { transform: translateX(100%); opacity: 0; } }
`;
document.head.appendChild(style);
