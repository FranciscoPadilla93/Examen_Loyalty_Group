using Store.Entities;

namespace Store.Data.Repositories
{
    public interface ITiendaRepository
    {
        Task<IEnumerable<Tienda>> GetAll();
        Task<Tienda?> GetById(int id);
        Task<bool> Create(Tienda tienda);
        Task<bool> Update(Tienda tienda);
        Task<bool> Delete(int id);
    }
}
