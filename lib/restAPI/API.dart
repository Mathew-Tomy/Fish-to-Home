class ApiUrl{

  static const String baseURL = "https://fishtohome.ca/";
  
  static const String demoUser = "demouser";
  static const String apiKey = "dSmyc8dV77yogTbfpmIJyh97mba3llqaJWlf4GP9";
  static const String token = "31fc311c855c692c93f1a3c3008dbde4";


// Auth routes
static const String login = baseURL + 'api/login';
static const String logout = baseURL + 'api/logout';
static const String forgotPassword = baseURL + 'api/forgot';
static const String accountUpdate = baseURL + 'api/changepassword';
static const String registration = baseURL + 'api/register';
static const String verifyLink = baseURL + 'api/verify_token'; // Updated to match PHP route

// Product routes
static const String productdetail = baseURL + 'api/products'; 
static const String products = baseURL + 'api/products-all';
static const String categories = baseURL + 'api/categories';  // Updated route
static const String categoryProducts = baseURL + 'api/cat-products/'; // Updated route
static const String ProductsType = baseURL +  'api/products/type/';

// Cart routes
static const String cartedit = baseURL + 'api/cart-update';  // Updated route
static const String cartreduce = baseURL + 'api/cart-reduce';  // Updated route
static const String addtocart = baseURL + 'api/cart';  // Updated route
static const String cartdelete = baseURL + 'api/cart-delete'; // Updated route
static const String cartClear = baseURL + 'api/cart-clear'; // Updated route
static const String cartProducts = baseURL + 'api/cart-products'; // Updated route

// Wishlist routes
static const String wishlist = baseURL + 'api/wishlist'; // Updated route
static const String wishlistremove = baseURL + 'api/wishlist-delete'; // Updated route
static const String wishlistClear = baseURL + 'api/wishlist-clear'; // Updated route
static const String wishlistProducts = baseURL + 'api/wishlist-products'; // Updated route

// Home routes
static const String slider = baseURL + 'api/slider';
static const String footer = baseURL + 'api/footer';
static const String best = baseURL + 'api/products-best';
static const String newProducts = baseURL + 'api/products-new';
static const String featuredProducts = baseURL + 'api/products-featured';
static const String allProducts = baseURL + 'api/products-all';
static const String search = baseURL + 'api/search';  // Updated route

// Order routes
static const String addresslist = baseURL + 'api/view-address-book';
static const String viewBillingBook = baseURL + 'api/view-billing-book';
static const String updateAddress = baseURL + 'api/update-address';
static const String addressadd = baseURL + 'api/address-book';

static const String orderList = baseURL + 'api/order-products'; // Updated route
static const String orderSummary = baseURL + 'api/view-order'; // Updated route

// Other routes
static const String homepage = baseURL + 'api/home'; // Adjusted for proper API endpoint

// Payment routes
static const String paymentAccount = baseURL + 'api/payment-account';
static const String paymentMethod = baseURL + 'api/payment-method'; // Adjusted for PHP API endpoint
static const String StripeCheckout = baseURL + 'api/checkout';

//Address routes
  static const String countries = baseURL + 'api/countries'; // Adjusted for PHP API endpoint
  static const String states = baseURL + 'api/state';
  static const String cities = baseURL + 'api/zipcode';


}