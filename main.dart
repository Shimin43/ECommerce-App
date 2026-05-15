import 'package:flutter/material.dart';
import 'dart:math';

// --- Models ---

class Product {
  final String id;
  String name; // Made mutable for admin editing
  String category; // Made mutable for admin editing
  double price; // Made mutable for admin editing
  String imagePath; // Made mutable for admin editing
  String description; // Made mutable for admin editing

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imagePath,
    required this.description,
  });

  // Helper method for update (used by AddEditProductScreen)
  Product copyWith({
    String? name,
    String? category,
    double? price,
    String? imagePath,
    String? description,
  }) {
    return Product(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      imagePath: imagePath ?? this.imagePath,
      description: description ?? this.description,
    );
  }
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}

class Order {
  final String id;
  final String userEmail;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime orderDate;
  String status; // e.g., 'Pending', 'Processing', 'Delivered'

  Order({
    required this.id,
    required this.userEmail,
    required this.items,
    required this.totalAmount,
    required this.orderDate,
    this.status = 'Pending',
  });
}

// --- Services ---

class AuthService extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _userEmail;
  bool _isAdmin = false;

  bool get isLoggedIn => _isLoggedIn;
  String? get userEmail => _userEmail;
  bool get isAdmin => _isAdmin;

  Future<void> attemptSignIn(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 700));

    if (email.contains('@') && password.length >= 6) {
      _userEmail = email;
      _isLoggedIn = true;
      _isAdmin = email == 'admin@chic.com'; // Admin Check
      notifyListeners();
    } else {
      throw Exception(
        'Invalid credentials. Please check your email and password.',
      );
    }
  }

  Future<void> attemptSignUp(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 700));

    if (email.contains('@') && password.length >= 6) {
      _userEmail = email;
      _isLoggedIn = true;
      _isAdmin = email == 'admin@chic.com';
      notifyListeners();
    } else {
      throw Exception('Signup failed. Password must be at least 6 characters.');
    }
  }

  void logOut() {
    _isLoggedIn = false;
    _userEmail = null;
    _isAdmin = false;
    ShopService._instance.clearUserSession(); // Use instance to call non-static method
    notifyListeners();
  }
}

final AuthService _authService = AuthService();

// --- Order Management Service (New) ---

class OrderService extends ChangeNotifier {
  static final OrderService _instance = OrderService._internal();
  factory OrderService() => _instance;
  OrderService._internal();

  final List<Order> _orders = [
    // Initial dummy order for demonstration
    Order(
      id: 'ORD000001',
      userEmail: 'admin@chic.com',
      items: [
        CartItem(product: ShopService.allProducts[0], quantity: 1),
      ],
      totalAmount: ShopService.allProducts[0].price,
      orderDate: DateTime.now().subtract(const Duration(days: 1)),
      status: 'Processing',
    )
  ];

  List<Order> get allOrders => [..._orders];

  void addOrder(Order order) {
    _orders.insert(0, order); // Add new orders to the top
    notifyListeners();
  }

  void updateOrderStatus(String orderId, String newStatus) {
    final orderIndex = _orders.indexWhere((o) => o.id == orderId);
    if (orderIndex != -1) {
      _orders[orderIndex].status = newStatus;
      notifyListeners();
    }
  }
}

final OrderService _orderService = OrderService();


class ShopService extends ChangeNotifier {
  // Prices in BDT (Bangladesh Taka)
  static final List<Product> _products = [
    Product(
      id: 'p1',
      name: 'Saree',
      category: 'Clothing',
      price: 5200.00 ,
      imagePath: 'assets/saree.png',
      description:
          'This Navy Blue Half Silk Saree exudes sophisticated charm with its subtle prints.',
    ),
    Product(
      id: 'p2',
      name: 'Three Pieces',
      category: 'Clothing',
      price: 4500.00,
      imagePath: 'assets/three_pieces.png',
      description:
          'Anarkoli Design Cotton Readymade Three Piece Skin Print Shalwar Kameez For Women ',
    ),
    Product(
      id: 'p3',
      name: 'Bag',
      category: 'Accessories',
      price: 2600.00,
      imagePath: 'assets/Bags.png',
      description:
          'Compact and stylish clutch, featuring a metallic clasp and fine grain texture.',
    ),
    Product(
      id: 'p4',
      name: 'Oversized Cateye Shades',
      category: 'Accessories',
      price: 2100.00,
      imagePath: 'assets/shades.png', 
      description:
          'Glamorous oversized sunglasses with UV protection and a bold cateye frame.',
    ),
    Product(
      id: 'p5',
      name: 'Quilted Shoulder Bag',
      category: 'Accessories',
      price: 10500.00,
      imagePath: 'assets/shoulder_bag.png', 
      description:
          'Premium quilted leather shoulder bag with gold-tone hardware and chain strap.',
    ),
    Product(
      id: 'p6',
      name: 'Cashmere Winter Scarf',
      category: 'Accessories',
      price: 3000.00,
      imagePath: 'assets/scarf.png',
      description:
          'Incredibly soft and lightweight cashmere blend scarf, essential for cool weather.',
    ),
    Product(
      id: 'p7',
      name: 'Velvet Block Heels',
      category: 'Shoes',
      price: 12500.00,
      imagePath: 'assets/Heels.png',
      description:
          'Comfortable yet stylish velvet block heels in a rich burgundy shade.',
    ),
    Product(
      id: 'p8',
      name: 'Crystal Stud Earrings',
      category: 'Accessories',
      price: 16500.00,
      imagePath: 'assets/earrings.png',
      description:
          'Dazzling stud earrings set with high-quality cubic zirconia crystals.',
    ),
    Product(
      id: 'p9',
      name: 'Ruffled Floral Dress',
      category: 'Clothing',
      price: 4100.00,
      imagePath: 'assets/floral_dress.png',
      description:
          'Lightweight summer dress featuring a delicate floral print and feminine ruffle details.',
    ),
    Product(
      id: 'p10',
      name: 'Silk Maxi Skirt',
      category: 'Clothing',
      price: 6800.00,
      imagePath: 'assets/skirt.png',
      description:
          'Flowing maxi skirt crafted from luxurious silk, designed for comfort and movement.',
    ),
  ];

  static final Map<String, int> _cart = {};
  static final Set<String> _wishlist = {};

  static final ShopService _instance = ShopService._internal();
  factory ShopService() => _instance;
  ShopService._internal();

  static List<Product> get allProducts => _products;

  void clearUserSession() {
    _cart.clear();
    _wishlist.clear();
    notifyListeners(); // Notify all listeners (Wishlist, Cart) when session clears
  }

  static List<CartItem> get cartItemsDetails {
    return _cart.entries.map((entry) {
      final product = _products.firstWhere((p) => p.id == entry.key);
      return CartItem(product: product, quantity: entry.value);
    }).toList();
  }

  static int getCartQuantity(String productId) => _cart[productId] ?? 0;

  static bool isInWishlist(String productId) => _wishlist.contains(productId);

  static void addToCart(String productId) {
    _cart.update(productId, (value) => value + 1, ifAbsent: () => 1);
    _instance.notifyListeners(); // CORRECTED: Added notifyListeners
  }

  static void removeFromCart(String productId) {
    if (_cart.containsKey(productId)) {
      _cart.update(productId, (value) => value - 1);
      if (_cart[productId]! <= 0) {
        _cart.remove(productId);
      }
      _instance.notifyListeners(); // CORRECTED: Added notifyListeners
    }
  }

  static void toggleWishlist(String productId) {
    if (_wishlist.contains(productId)) {
      _wishlist.remove(productId);
    } else {
      _wishlist.add(productId);
    }
    _instance.notifyListeners(); // CORRECTED: Added notifyListeners
  }

  static double getCartTotal() {
    double total = 0.0;
    _cart.forEach((productId, quantity) {
      final product = _products.firstWhere((p) => p.id == productId);
      total += product.price * quantity;
    });
    return total;
  }

  static String formatCurrency(double amount) {
    return '৳${amount.toStringAsFixed(2)}';
  }

  // --- Admin Product Management Methods ---

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void updateProduct(Product updatedProduct) {
    final index = _products.indexWhere((p) => p.id == updatedProduct.id);
    if (index != -1) {
      // Create a mutable copy and update it in the list
      _products[index] = updatedProduct.copyWith(
        name: updatedProduct.name,
        category: updatedProduct.category,
        price: updatedProduct.price,
        imagePath: updatedProduct.imagePath,
        description: updatedProduct.description,
      );
      // Since Product fields are mutable, the simple assignment works too,
      // but using copyWith ensures we are using the helper method if the original
      // Product class were fully final. Given the structure, a direct replace is fine.
      _products[index] = updatedProduct;

      notifyListeners();
    }
  }

  void deleteProduct(String productId) {
    _products.removeWhere((p) => p.id == productId);
    // Remove from cart and wishlist if present
    _cart.remove(productId);
    _wishlist.remove(productId);
    notifyListeners();
  }

  // --- Checkout/Order Placement Method ---
  void placeOrder(String userEmail) {
    if (_cart.isEmpty) return;

    final items = cartItemsDetails;
    final total = getCartTotal();

    final order = Order(
      id: 'ORD${Random().nextInt(999999).toString().padLeft(6, '0')}',
      userEmail: userEmail,
      items: items,
      totalAmount: total,
      orderDate: DateTime.now(),
      status: 'Pending',
    );

    _orderService.addOrder(order);
    _cart.clear(); // Clear the cart after placing the order
    notifyListeners(); // Notify listeners (Cart screen)
  }
}

// --- Main App Entry Point ---

void main() {
  runApp(const ECommerceApp());
}

class ECommerceApp extends StatelessWidget {
  const ECommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _authService, // Listen to auth state changes
      builder: (context, child) {
        return ListenableBuilder(
          listenable: ShopService(), // Ensure ShopService instance is created and listened to
          builder: (context, child) {
            return MaterialApp(
              title: 'Chic Catalog',
              theme: ThemeData(
                primarySwatch: Colors.pink,
                primaryColor: const Color(0xFFC2185B), // Deep Pink/Fuchsia
                appBarTheme: const AppBarTheme(
                  backgroundColor: Color(0xFFC2185B),
                  foregroundColor: Colors.white,
                  elevation: 1,
                  titleTextStyle: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                scaffoldBackgroundColor: const Color(
                  0xFFFDEEF4,
                ), // Soft Light Pink Background
                buttonTheme:
                    const ButtonThemeData(buttonColor: Color(0xFFE91E63)),
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE91E63),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  ),
                ),
                fontFamily: 'Inter',
                useMaterial3: true,
              ),
              home: _authService.isLoggedIn ? const MainScreen() : const AuthScreen(),
            );
          },
        );
      },
    );
  }
}

// --- Authentication Screen ---

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;
  String? _errorMessage;

  void _submitAuthForm() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (_isLogin) {
        await _authService.attemptSignIn(
          _emailController.text,
          _passwordController.text,
        );
      } else {
        await _authService.attemptSignUp(
          _emailController.text,
          _passwordController.text,
        );
      }
    } on Exception catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isLogin ? 'Welcome Back!' : 'Create Account',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isLogin
                    ? 'Sign in to access your stylish catalog.'
                    : 'Join the elegance.',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 32),
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: Color(0xFFE91E63),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: Color(0xFFE91E63),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      _isLoading
                          ? const CircularProgressIndicator(
                              color: Color(0xFFE91E63),
                            )
                          : ElevatedButton(
                              onPressed: _submitAuthForm,
                              child: Text(_isLogin ? 'LOGIN' : 'SIGN UP'),
                            ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLogin = !_isLogin;
                    _errorMessage = null;
                  });
                },
                child: Text(
                  _isLogin
                      ? 'New user? Create an account'
                      : 'Already have an account? Login',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Main App Screens Wrapper ---

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  List<Widget> get _widgetOptions {
    final screens = <Widget>[
      const ProductListScreen(),
      const WishlistScreen(),
      const CartScreen(),
    ];

    if (_authService.isAdmin) {
      screens.add(const AdminDashboardScreen());
    }
    return screens;
  }

  List<BottomNavigationBarItem> get _navItems {
    final items = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(
        icon: Icon(Icons.shopping_bag_outlined),
        label: 'Shop',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.favorite_outline),
        label: 'Wishlist',
      ),
      BottomNavigationBarItem(
        icon: ListenableBuilder(
          listenable: ShopService(),
          builder: (context, _) {
            final cartCount = ShopService.cartItemsDetails.fold(
                0, (sum, item) => sum + item.quantity);
            return Badge(
              label: Text(cartCount.toString()),
              isLabelVisible: cartCount > 0,
              child: const Icon(Icons.shopping_cart_outlined),
            );
          },
        ),
        label: 'Cart',
      ),
    ];

    if (_authService.isAdmin) {
      items.add(
        const BottomNavigationBarItem(
          icon: Icon(Icons.admin_panel_settings_outlined),
          label: 'Admin',
        ),
      );
    }
    return items;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: _navItems,
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey[600],
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        elevation: 10,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

// --- Product List Screen ---

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  late ShopService _shopService;

  @override
  void initState() {
    super.initState();
    _shopService = ShopService();
    // No need to add/remove listener here as the parent ECommerceApp already handles ShopService
  }

  List<Product> get _filteredProducts {
    var products = ShopService.allProducts;

    if (_selectedCategory != 'All') {
      products =
          products.where((p) => p.category == _selectedCategory).toList();
    }

    if (_searchQuery.isNotEmpty) {
      products = products
          .where(
            (p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }

    return products;
  }

  List<String> get _categories {
    final categories = ShopService.allProducts.map((p) => p.category).toSet();
    return ['All', ...categories];
  }

  void _onProductUpdate() {
    // This is called from the grid item when navigation returns or an internal
    // action like wishlist toggle happens. Since the parent listens to ShopService
    // and rebuilds the MaterialApp, this local setState is primarily for
    // category/search filter changes.
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chic Catalog'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _authService.logOut(),
            tooltip: 'Logout',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56.0),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 8.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search elegance...',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFFE91E63),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.pink[100]!),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCategory,
                      icon: const Icon(
                        Icons.filter_list,
                        color: Color(0xFFE91E63),
                      ),
                      items: _categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(
                            category,
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCategory = newValue!;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListenableBuilder(
        listenable: _shopService,
        builder: (context, child) {
          final products = _filteredProducts;
          if (products.isEmpty) {
            return Center(
              child: Text(
                'No products match your filter criteria.',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(12.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              childAspectRatio: 0.7,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductGridItem(
                  product: product, onUpdate: _onProductUpdate);
            },
          );
        },
      ),
    );
  }
}

// Product Grid Item Widget
class ProductGridItem extends StatelessWidget {
  final Product product;
  final VoidCallback onUpdate;

  const ProductGridItem({
    super.key,
    required this.product,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final isInWishlist = ShopService.isInWishlist(product.id);

    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder: (ctx) => ProductDetailScreen(product: product),
              ),
            )
            .then((_) => onUpdate());
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.asset( // FIX: Ensures Image.asset is used
                    product.imagePath,
                    height: 320,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 420,
                      color: Colors.pink[50],
                      child: Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.pink[200],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      icon: Icon(
                        isInWishlist ? Icons.favorite : Icons.favorite_border,
                        color: isInWishlist ? Colors.redAccent : Colors.white,
                      ),
                      onPressed: () {
                        ShopService.toggleWishlist(product.id);
                        onUpdate();
                      },
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    ShopService.formatCurrency(product.price),
                    style: TextStyle(
                      color: Colors.green[700],
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Product Detail Screen ---

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late bool _isInWishlist;
  late int _cartQuantity;

  @override
  void initState() {
    super.initState();
    _updateLocalState();
  }

  // Listens to ShopService state changes to keep UI updated
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ShopService().addListener(_handleServiceUpdate);
  }

  @override
  void dispose() {
    ShopService().removeListener(_handleServiceUpdate);
    super.dispose();
  }

  void _handleServiceUpdate() {
    if (mounted) {
      setState(() {
        _updateLocalState();
      });
    }
  }

  void _updateLocalState() {
    _isInWishlist = ShopService.isInWishlist(widget.product.id);
    _cartQuantity = ShopService.getCartQuantity(widget.product.id);
  }

  void _toggleWishlist() {
    ShopService.toggleWishlist(widget.product.id);
    // State is updated via _handleServiceUpdate
  }

  void _addToCart() {
    ShopService.addToCart(widget.product.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.name} added to cart!'),
        duration: const Duration(seconds: 1),
      ),
    );
    // State is updated via _handleServiceUpdate
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        actions: [
          IconButton(
            icon: Icon(
              _isInWishlist ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
            ),
            onPressed: _toggleWishlist,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset( // FIX: Ensures Image.asset is used
              widget.product.imagePath,
              height: 400,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 400,
                color: Colors.pink[50],
                child: Center(
                  child: Icon(
                    Icons.image_not_supported,
                    size: 50,
                    color: Colors.pink[200],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFC2185B),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    ShopService.formatCurrency(widget.product.price),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.green[700],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Details:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  Text(
                    widget.product.description,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _addToCart,
                      icon: const Icon(Icons.add_shopping_cart),
                      label: Text(
                        _cartQuantity > 0
                            ? 'Add More (In Cart: $_cartQuantity)'
                            : 'Add to Cart',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Wishlist Screen ---

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  late ShopService _shopService;

  @override
  void initState() {
    super.initState();
    _shopService = ShopService();
    _shopService.addListener(_refreshScreen);
  }

  @override
  void dispose() {
    _shopService.removeListener(_refreshScreen);
    super.dispose();
  }

  void _refreshScreen() {
    setState(() {});
  }

  List<Product> get _wishlistProducts {
    return ShopService.allProducts
        .where((p) => ShopService.isInWishlist(p.id))
        .toList();
  }

  void _removeProductFromWishlist(String productId) {
    ShopService.toggleWishlist(productId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Removed from wishlist.')),
    );
  }

  void _addToCartFromWishlist(Product product) {
    ShopService.addToCart(product.id);
    ShopService.toggleWishlist(product.id); // Also remove from wishlist
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.name} moved to cart!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = _wishlistProducts;

    return Scaffold(
      appBar: AppBar(title: const Text('Your Wishlist')),
      body: products.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border,
                      size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Your wishlist is empty!',
                    style: TextStyle(fontSize: 20, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start adding your favorite pieces.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Dismissible(
                  key: ValueKey(product.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    _removeProductFromWishlist(product.id);
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white, size: 30),
                  ),
                  child: WishlistItemCard(
                    product: product,
                    onMoveToCart: () => _addToCartFromWishlist(product),
                    onRemove: () => _removeProductFromWishlist(product.id),
                  ),
                );
              },
            ),
    );
  }
}

class WishlistItemCard extends StatelessWidget {
  final Product product;
  final VoidCallback onMoveToCart;
  final VoidCallback onRemove;

  const WishlistItemCard({
    super.key,
    required this.product,
    required this.onMoveToCart,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                product.imagePath,
                width: 80,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 80,
                  height: 90,
                  color: Colors.pink[50],
                  child: Center(
                    child: Icon(Icons.image_not_supported,
                        color: Colors.pink[200]),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ShopService.formatCurrency(product.price),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: onRemove,
                ),
                TextButton(
                  onPressed: onMoveToCart,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    foregroundColor: Theme.of(context).primaryColor,
                  ),
                  child: const Text(
                    'Move to Cart',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// --- Cart Screen ---

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // We listen to ShopService via ListenableBuilder in the build method

  void _simulateCheckout(double total) {
    if (total == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your cart is empty!')),
      );
      return;
    }

    final userEmail = _authService.userEmail ?? 'guest@user.com';
    ShopService().placeOrder(userEmail); // Call instance method

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Order Placed!',
          style: TextStyle(color: Color(0xFFC2185B)),
        ),
        content: Text(
          'Your elegant order totaling ${ShopService.formatCurrency(total)} has been placed successfully under $userEmail. Thank you for shopping with us!',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Close',
              style: TextStyle(color: Color(0xFFC2185B)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ShopService(), // Listen directly to ShopService
      builder: (context, child) {
        final cartItems = ShopService.cartItemsDetails;
        final cartTotal = ShopService.getCartTotal();

        return Scaffold(
          appBar: AppBar(title: const Text('Your Cart')),
          body: cartItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart,
                          size: 80, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'Your cart awaits beauty!',
                        style: TextStyle(fontSize: 20, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return CartItemCard(
                            product: item.product,
                            quantity: item.quantity,
                            // No need to pass onUpdate as it listens to ShopService
                          );
                        },
                      ),
                    ),
                    Container(
                      // FIX: Completed the missing Container code
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                        borderRadius:
                            const BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total:',
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                ShopService.formatCurrency(cartTotal),
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => _simulateCheckout(cartTotal),
                              icon: const Icon(Icons.payment),
                              label: const Text(
                                'PROCEED TO CHECKOUT',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class CartItemCard extends StatelessWidget {
  final Product product;
  final int quantity;

  const CartItemCard({
    super.key,
    required this.product,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                product.imagePath,
                width: 70,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ShopService.formatCurrency(product.price),
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    'Subtotal: ${ShopService.formatCurrency(product.price * quantity)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.green[700],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    ShopService.removeFromCart(product.id);
                  },
                ),
                Text(
                  '$quantity',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    ShopService.addToCart(product.id);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// --- Admin Screens ---

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, Admin!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            AdminCard(
              icon: Icons.inventory,
              title: 'Product Management',
              subtitle: 'Add, edit, or delete catalog items.',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (ctx) => const ProductManagementScreen()),
                );
              },
            ),
            AdminCard(
              icon: Icons.receipt_long,
              title: 'Order Management',
              subtitle: 'Track and update customer orders.',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (ctx) => const OrderManagementScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AdminCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const AdminCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(
          icon,
          size: 40,
          color: Theme.of(context).primaryColor,
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}

// --- Product Management Screen (Admin) ---

class ProductManagementScreen extends StatefulWidget {
  const ProductManagementScreen({super.key});

  @override
  State<ProductManagementScreen> createState() => _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
  late ShopService _shopService;

  @override
  void initState() {
    super.initState();
    _shopService = ShopService();
    _shopService.addListener(_refreshScreen);
  }

  @override
  void dispose() {
    _shopService.removeListener(_refreshScreen);
    super.dispose();
  }

  void _refreshScreen() {
    setState(() {});
  }

  void _navigateToAddEditProduct(Product? product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => AddEditProductScreen(product: product),
      ),
    );
  }

  void _deleteProduct(String productId, String productName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete "$productName"?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _shopService.deleteProduct(productId);
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$productName deleted.')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = ShopService.allProducts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Management'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: ListenableBuilder(
        listenable: _shopService,
        builder: (context, child) {
          if (products.isEmpty) {
            return const Center(child: Text('No products available.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                elevation: 2,
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.asset(
                      product.imagePath,
                      width: 50,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 50,
                        height: 70,
                        color: Colors.grey[200],
                        child: const Icon(Icons.broken_image),
                      ),
                    ),
                  ),
                  title: Text(product.name),
                  subtitle: Text(
                      '${product.category} | ${ShopService.formatCurrency(product.price)}'),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _navigateToAddEditProduct(product),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              _deleteProduct(product.id, product.name),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        onPressed: () => _navigateToAddEditProduct(null),
        child: const Icon(Icons.add),
      ),
    );
  }
}

// --- Add/Edit Product Screen (Admin) ---

class AddEditProductScreen extends StatefulWidget {
  final Product? product;
  const AddEditProductScreen({super.key, this.product});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late ShopService _shopService;
  late String _id;
  late String _name;
  late String _category;
  late double _price;
  late String _imageUrl;
  late String _description;

  @override
  void initState() {
    super.initState();
    _shopService = ShopService();
    final isEditing = widget.product != null;
    _id = isEditing
        ? widget.product!.id
        : 'p${ShopService.allProducts.length + 1 + Random().nextInt(100)}';
    _name = isEditing ? widget.product!.name : '';
    _category = isEditing ? widget.product!.category : 'Clothing';
    _price = isEditing ? widget.product!.price : 0.0;
    _imageUrl = isEditing
        ? widget.product!.imagePath
        : 'assets/saree.png'; // Default to a valid asset
    _description = isEditing ? widget.product!.description : '';
  }

  void _saveForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    final newProduct = Product(
      id: _id,
      name: _name,
      category: _category,
      price: _price,
      imagePath: _imageUrl,
      description: _description,
    );

    if (widget.product == null) {
      _shopService.addProduct(newProduct);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added successfully!')),
      );
    } else {
      _shopService.updateProduct(newProduct);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product updated successfully!')),
      );
    }
    Navigator.of(context).pop();
  }

  void _updateImageUrl(String url) {
    setState(() {
      _imageUrl = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    const List<String> categories = ['Clothing', 'Accessories', 'Shoes'];
    final isEditing = widget.product != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Product' : 'Add New Product'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveForm),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: _name,
                  decoration: const InputDecoration(labelText: 'Product Name'),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a name.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value!;
                  },
                ),
                TextFormField(
                  initialValue: _price == 0.0 ? '' : _price.toString(),
                  decoration: const InputDecoration(labelText: 'Price (BDT)'),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a price.';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number.';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Price must be greater than zero.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _price = double.parse(value!);
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: _category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _category = newValue!;
                    });
                  },
                  onSaved: (value) {
                    _category = value!;
                  },
                ),
                TextFormField(
                  initialValue: _imageUrl,
                  decoration: const InputDecoration(labelText: 'Image Asset Path'),
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter an image path.';
                    }
                    if (!value.startsWith('assets/')) {
                       return 'Must be a local asset path (e.g., assets/image.png).';
                    }
                    return null;
                  },
                  onChanged: _updateImageUrl, // Live update preview
                  onSaved: (value) {
                    _imageUrl = value!;
                  },
                ),
                TextFormField(
                  initialValue: _description,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a description.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _description = value!;
                  },
                ),
                const SizedBox(height: 20),
                // Dynamic image loading for local assets
                SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: Image.asset(
                    _imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[200],
                      child: const Center(child: Text('Invalid Asset Path')),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: _saveForm,
                  icon: const Icon(Icons.check),
                  label: Text(isEditing ? 'UPDATE PRODUCT' : 'ADD PRODUCT'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- Order Management Screen (Admin) ---

class OrderManagementScreen extends StatefulWidget {
  const OrderManagementScreen({super.key});

  @override
  State<OrderManagementScreen> createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> {
  late OrderService _orderService;

  @override
  void initState() {
    super.initState();
    _orderService = OrderService();
    _orderService.addListener(_refreshScreen);
  }

  @override
  void dispose() {
    _orderService.removeListener(_refreshScreen);
    super.dispose();
  }

  void _refreshScreen() {
    setState(() {});
  }

  void _updateStatus(Order order, String newStatus) {
    _orderService.updateOrderStatus(order.id, newStatus);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order ${order.id} status set to $newStatus')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orders = _orderService.allOrders;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Management'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: ListenableBuilder(
        listenable: _orderService,
        builder: (context, child) {
          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.list_alt, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text(
                    'No pending orders.',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return OrderCard(
                order: order,
                onStatusChange: _updateStatus,
              );
            },
          );
        },
      ),
    );
  }
}

// Order Card Widget
class OrderCard extends StatelessWidget {
  final Order order;
  final Function(Order, String) onStatusChange;

  const OrderCard({
    super.key,
    required this.order,
    required this.onStatusChange,
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Delivered':
        return Colors.green;
      case 'Processing':
        return Colors.orange;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(order.status);
    const List<String> statuses = ['Pending', 'Processing', 'Delivered', 'Cancelled'];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text(
          order.id,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('User: ${order.userEmail} | ${_formatDate(order.orderDate)}'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            order.status,
            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(
                      ShopService.formatCurrency(order.totalAmount),
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
                const Divider(),
                const Text('Items:', style: TextStyle(fontWeight: FontWeight.w600)),
                ...order.items.map((item) => Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 4),
                  child: Text('${item.product.name} x ${item.quantity}'),
                )),
                const Divider(),
                // Status Update Dropdown
                DropdownButtonFormField<String>(
                  initialValue: order.status,
                  decoration: InputDecoration(
                    labelText: 'Update Status',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
                  ),
                  items: statuses.map((String status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null && newValue != order.status) {
                      onStatusChange(order, newValue);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}