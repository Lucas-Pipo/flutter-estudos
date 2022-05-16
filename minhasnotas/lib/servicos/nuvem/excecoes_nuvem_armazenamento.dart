class NuvemArmazenamentoExcecao implements Exception {
  const NuvemArmazenamentoExcecao();
}

//C em CRUD
class NaoConseguiuCriarNotaExcecao extends NuvemArmazenamentoExcecao {}

// R em CRUD
class NaoConseguiuPegarTodasAsNotasExcecao extends NuvemArmazenamentoExcecao {}

// U em CRUD
class NaoConseguiuAtualizarNotasExcecao extends NuvemArmazenamentoExcecao {}

// D em CRUD
class NaoConseguiuDeletarExececao extends NuvemArmazenamentoExcecao {}
