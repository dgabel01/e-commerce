export default function Footer() {
  return (
    <footer className="bg-[#F4F4F4] text-[#050505] py-10 ">
      <div className="max-w-[1440px] mx-auto px-6 lg:px-10 flex flex-col lg:flex-row lg:justify-between gap-10">

        {/* Newsletter */}
        <div className="order-1 lg:order-3 flex flex-col w-full lg:w-[384px] lg:mr-[5px]">
          <h4 className="text-[32px] font-[500] mb-3 leading-[140%]">Join our newsletter</h4>
          <p className="mt-2 mb-4 font-[400] text-[16px] leading-[140%]">We will also send you our discount coupons!</p>
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
          <p className="mt-3 text-[12px] font-[400] leading-[140%] text-[#808080]">
            By subscribing you agree to with our <span className="underline">Privacy Policy</span> and provide consent to receiove updates from our company.
          </p>
        </div>

        {/* SofaSocietyCo */}
        <div className="order-2 font-[500] lg:order-1 flex top-[80px] left-[96px] flex-col items-center lg:items-start w-full lg:w-[168px] lg:h-[152px] lg:ml-4">
          <span className="text-[40px] font-medium leading-[90%]">Sofa</span>
          <span className="text-[40px] font-medium leading-[90%]">Society</span>
          <span className="text-[40px] font-medium leading-[90%]">Co.</span>
          <p className="text-[12px] font-[400] leading-[140%] text-[#050505] mt-4">© 2024, Sofa Society</p>
        </div>

        {/* Rows */}
        <div className="order-3 lg:order-2 flex-1 flex flex-row justify-between gap-6 px-2 lg:px-6 lg:w-[384px] lg:h-[160px] lg:top-[80px] lg:left-[420px]">
          <nav className="flex flex-col gap-2 flex-1 min-w-[0] leading-[140%] text-[16px]">
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
          <nav className="flex flex-col gap-2 flex-1 min-w-[0] mx-4">
            <a className="font-normal whitespace-nowrap">Privacy Policy</a>
            <a className="font-normal whitespace-nowrap">Cookie Policy</a>
            <a className="font-normal whitespace-nowrap">Terms of Use</a>
          </nav>

        </div>
      </div>
    </footer>
  );
}
