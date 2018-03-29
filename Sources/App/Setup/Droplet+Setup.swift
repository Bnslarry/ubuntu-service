@_exported import Vapor

extension Droplet {
    public func setup() throws {
        try setupRoutes()
        try sellerRegister()
        try UserRegister()
        try SellerLogin()
        try SellerUpdate()
        try postAndGetImage()
        try UserLogin()
        try UserUpdate()
        try SubmitProduct()
        try GetProduct()
        try ManageProduct()
        try SearchProduct()
        try AddToCart()
        try OrderManage()
        try UploadUserList()
        try ManageRequestList()
        // Do any additional droplet setup
    }
}
