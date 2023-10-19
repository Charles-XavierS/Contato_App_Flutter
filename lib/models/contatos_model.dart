class ContatosModel {
  List<Contatos> contatos = [];

  ContatosModel(this.contatos, {String? nome});

  ContatosModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      contatos = <Contatos>[];
      json['results'].forEach((v) {
        contatos.add(Contatos.fromJson(v));
      });
    } else {
      contatos.add(Contatos.fromJson(json));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['results'] = contatos.map((v) => v.toJson()).toList();
    return data;
  }
}

class Contatos {
  String? objectId;
  String? nome;
  String? sobrenome;
  Telefones? telefones;
  String? email;
  String? site;
  String? pathFoto;
  List<int>? cor;
  String? createdAt;
  String? updatedAt;

  Contatos({
    this.objectId,
    this.nome,
    this.sobrenome,
    this.telefones,
    this.email,
    this.site,
    this.pathFoto,
    this.cor,
    this.createdAt,
    this.updatedAt,
  });

  Contatos.criar({
    this.nome,
    this.sobrenome,
    this.telefones,
    this.email,
    this.site,
    this.pathFoto,
    this.cor,
  });

  Contatos.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    nome = json['Nome'];
    sobrenome = json['Sobrenome'];
    telefones = Telefones.fromJson(json['Telefones']);
    email = json['Email'];
    site = json['Site'];
    pathFoto = json['PathFoto'];
    cor = (json['Cor'] as List).cast<int>();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['objectId'] = objectId;
    data['Nome'] = nome;
    data['Sobrenome'] = sobrenome;
    data['Telefones'] = telefones?.toJson();
    data['Email'] = email;
    data['Site'] = site;
    data['PathFoto'] = pathFoto;
    data['Cor'] = cor;
    return data;
  }
}

class Telefones {
  String? celular;
  String? trabalho;

  Telefones({
    this.celular,
    this.trabalho,
  });

  Telefones.fromJson(Map<String, dynamic> json) {
    celular = json['Celular'];
    trabalho = json['Trabalho'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Celular'] = celular;
    data['Trabalho'] = trabalho;
    return data;
  }
}
