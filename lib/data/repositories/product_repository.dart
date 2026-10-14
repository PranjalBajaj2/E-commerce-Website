import '../../domain/models/product.dart';

class ProductRepository {
  List<Product> getProducts() {
    return const [
      Product(
        id: 1,
        name: "Lumina Pro Wireless Headphones",
        category: "Audio",
        price: 349.00,
        rating: 4.9,
        reviews: 124,
        description:
            "Experience premium sound with Lumina Pro. Advanced active noise cancellation, 40-hour battery life, and ultra-soft memory foam ear cushions.",
        image: "assets/hero.png",
        badge: "Best Seller",
        availableColorValues: [0xFF0F172A, 0xFF475569, 0xFFE2E8F0],
      ),
      Product(
        id: 2,
        name: "Stealth Titanium Smartwatch",
        category: "Wearables",
        price: 199.00,
        rating: 4.7,
        reviews: 89,
        description:
            "A blend of luxury and tech. Featuring a sapphire crystal display, titanium body, and full fitness ecosystem integration.",
        image: "assets/watch.png",
        badge: "Limited",
        availableColorValues: [0xFF1E293B, 0xFF94A3B8, 0xFFF1F5F9],
      ),
      Product(
        id: 3,
        name: "Aura Minimalist Table Lamp",
        category: "Home",
        price: 79.00,
        rating: 4.8,
        reviews: 56,
        description:
            "Sleek, atmospheric, and smart. The Aura lamp offers dynamic color temperatures and integrated wireless charging for your devices.",
        image: "https://images.unsplash.com/photo-1507473885765-e6ed057f782c?q=80&w=1200",
        badge: "New",
        availableColorValues: [0xFFF8FAFC, 0xFFD97706, 0xFF1E293B],
      ),
      Product(
        id: 4,
        name: "Nomad Matte Black DSLR",
        category: "Electronics",
        price: 899.00,
        rating: 4.6,
        reviews: 42,
        description:
            "Capture life's moments in stunning clarity. Modern mirrorless tech in a rugged, minimalist matte black body.",
        image: "https://images.unsplash.com/photo-1516035069371-29a1b244cc32?q=80&w=1200",
        badge: "Premium",
        availableColorValues: [0xFF000000, 0xFF334155],
      ),
      Product(
        id: 5,
        name: "Sonic H1 Bluetooth Speaker",
        category: "Audio",
        price: 129.00,
        rating: 4.7,
        reviews: 156,
        description:
            "Compact size, legendary sound. 360-degree audio that fills any room, with a waterproof design for any adventure.",
        image: "https://images.unsplash.com/photo-1589003077984-894e133dabab?q=80&w=1200",
        badge: "Popular",
        availableColorValues: [0xFF0284C7, 0xFF0F172A, 0xFFE2E8F0],
      ),
      Product(
        id: 6,
        name: "Kinetics Ergonomic Keyboard",
        category: "Accessories",
        price: 149.00,
        rating: 4.9,
        reviews: 28,
        description:
            "Designed for ultimate productivity and comfort. Mechanical switches with a premium aluminum layout and customizable RGB backlight.",
        image: "https://images.unsplash.com/photo-1511467687858-23d96c32e4ae?q=80&w=1200",
        badge: "Designer's Choice",
        availableColorValues: [0xFF1E293B, 0xFFCBD5E1],
      ),
    ];
  }

  List<String> getCategories() {
    return const [
      "All",
      "Audio",
      "Wearables",
      "Home",
      "Electronics",
      "Accessories",
    ];
  }
}
