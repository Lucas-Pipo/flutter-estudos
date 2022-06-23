class NuvemArmazenamentoExcecao implements Exception {
  const NuvemArmazenamentoExcecao();
}

//C em CRUD
class NaoConseguiuCriarNotaExcecao extends NuvemArmazenamentoExcecao {}

// R em CRUD
class NaoConseguiuPegarTodasAsNotasExcecao extends NuvemArmazenamentoExcecao {}

// U em CRUD
class CouldNotUpdateNoteException extends NuvemArmazenamentoExcecao {}

// D em CRUD
class CouldNotDeleteNoteException extends NuvemArmazenamentoExcecao {}
