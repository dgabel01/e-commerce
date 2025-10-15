import Collection from "@/components/products/Collection"
import Hero from "@/components/products/Hero"
import { RelatedProducts } from "@/components/products/RelatedProducts"

export default async function ProductsPage() {
  return (
    <main>
      <Hero/>
      <Collection/>
      <RelatedProducts/>
    </main>
  )
}
