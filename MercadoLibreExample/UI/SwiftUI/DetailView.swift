import SwiftUI

struct DetailView: View {
    
    var selected: MercadoLibre.Item
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                buildLabel(prefix: "detail.name", selected.title)
                buildLabel(prefix: "detail.domain", selected.domainId)
                buildLabel(prefix: "detail.category", selected.category)
                buildLabel(prefix: "detail.acceptsMercadopago", selected.acceptsMercadopago?.description.localized)
                Spacer()
            }
            .navigationBarTitle(Text("navigation.detail.title"), displayMode: .inline)
            .padding()
        }
    }
    
    private func buildLabel(prefix: LocalizedStringKey, _ str: String?) -> AnyView? {
        guard let str = str else { return nil }
        return AnyView(Text(prefix) + Text(str))
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(selected: .mock("0001"))
    }
}
