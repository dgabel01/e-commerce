export default function Footer() {
  return (
    <footer className="bg-[#F4F4F4] text-[#050505] py-10 ">
      <div className="max-w-[1440px] mx-auto px-6 lg:px-10 flex flex-col lg:flex-row lg:justify-between gap-10">

        {/* Newsletter */}
        <div className="order-1 lg:order-3 flex flex-col w-full lg:w-[384px] lg:mr-[80px]">
          <h6 className="text-lg font-semibold mb-3">Join our newsletter</h6>
          <form className="flex flex-col sm:flex-row gap-2 w-full">
            <input
              type="email"
              placeholder="Enter your email"
              className="input input-bordered w-full sm:flex-1"
            />
            <button type="submit" className="btn btn-neutral whitespace-nowrap">
              Subscribe
            </button>
          </form>
          <p className="text-sm text-gray-500 mt-3">
            Subscribe to receive updates, exclusive offers, and design inspiration.
          </p>
        </div>

        {/* SofaSocietyCo */}
        <div className="order-2 lg:order-1 flex flex-col items-center lg:items-start w-full lg:w-[168px] lg:ml-4">
          <span className="text-[40px] font-medium leading-[90%]">Sofa</span>
          <span className="text-[40px] font-medium leading-[90%]">Society</span>
          <span className="text-[40px] font-medium leading-[90%]">Co.</span>
          <p className="text-sm text-[#050505] mt-4">© 2024, Sofa Society</p>
        </div>

        {/* Rows */}
        <div className="order-3 lg:order-2 flex-1 flex flex-row justify-between w-full gap-6 px-4 lg:px-6">
          <nav className="flex flex-col gap-2 flex-1 min-w-[0]">
            <a className="font-normal">FAQ</a>
            <a className="font-normal">Help</a>
            <a className="font-normal">Delivery</a>
            <a className="font-normal">Returns</a>
          </nav>
          <nav className="flex flex-col gap-2 flex-1 min-w-[0]">
            <a className="font-normal">Instagram</a>
            <a className="font-normal">TikTok</a>
            <a className="font-normal">Pinterest</a>
            <a className="font-normal">Facebook</a>
          </nav>
          <nav className="flex flex-col gap-2 flex-1 min-w-[0]">
            <a className="font-normal whitespace-nowrap">Privacy Policy</a>
            <a className="font-normal whitespace-nowrap">Cookie Policy</a>
            <a className="font-normal whitespace-nowrap">Terms of Use</a>
          </nav>

        </div>
      </div>
    </footer>
  );
}
