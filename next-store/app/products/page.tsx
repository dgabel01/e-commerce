import Collection from "@/components/products/Collection"
import Hero from "@/components/products/Hero"
import { RelatedProducts } from "@/components/products/RelatedProducts"

export default async function ProductsPage() {
  return (
    <main>
      <Hero productId="prod_01K7P7DXVF2Y1MMY4NXFW2PQ6A" regionId="reg_01K7ES77EXHRJ5EH6TDSCEKES8" />
      <Collection/>
      <RelatedProducts/>
    </main>
  )
}
